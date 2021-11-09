//
//  BaseChart.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/05.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseChart<T:BaseChartCell<T1>, T1:Any>: UICollectionView, UICollectionViewDelegateFlowLayout {
    
    required init?(coder: NSCoder) {
        fatalError(#file + ":" + #function + " method must be overridden.")
    }
    
    // Properties
    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private var cellWidth: Double
    
    init(cellWidth: Double) {
        self.cellWidth = cellWidth
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        setup()
    }
    
    func setup() {
        setupLayout()
        subscribe()
    }
    
    // MARK: - Rx things
    lazy var disposeBag = DisposeBag()
    lazy var rxData = BehaviorSubject<ChartRawDataType>(value: [])
    lazy var rxScale = BehaviorSubject<Double>(value: 1)
    
    func subscribe() {
        bindCollectionView()
        bindData()
    }
    
    // MARK: - Override methods
    func transform(data: ChartRawDataType) -> [T1] {
        fatalError(#file + ":" + #function + " method must be overridden.")
    }
    
    func isPadding(atPosition: Int) -> Bool {
        return false
    }
    
    // MARK: -
    func bindData() {
        // bind data into UICollectionView
        rxData
            .filter{ $0.count > 0 }
            // Normalize input data into range [0..1]
            .map { arr -> ChartRawDataType in
                let min = arr.min()!
                let max = arr.max()!
                return arr.map {
                    ($0 - min)/(max - min)
                }
            }
            // create tuple of (n, n+1) elements
            // ignore nil element (arr[n] is the last element) with compactMap
            .map { self.transform(data: $0) }
            //
            .bind(to: self.rx.items(cellIdentifier: T.CellId, cellType: T.self)) { row, data, cell in
                cell.backgroundColor = self.backgroundColor
                cell.setData(data)
            }
            .disposed(by: disposeBag)
    }
    
    func bindCollectionView() {
        // UICollectionViewCell size
        self.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        // Zoom
        rxScale
            .subscribe { _ in
                self.collectionViewLayout.invalidateLayout()
            }
            .disposed(by: disposeBag)
    }

    func setupLayout() {
        // UICollectionView as chart visual
        self ~ {
            $0.setCollectionViewLayout(layout, animated: false)
            $0.bounces = false
            $0.showsHorizontalScrollIndicator = false
            $0.register(T.self, forCellWithReuseIdentifier: T.CellId)
        }
    }
    
    // Chart Delegate
    // Swift do not allow to extend generic class so I do it inside
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = CGFloat(self.cellWidth)
        var cellSize = CGSize(width: 0, height: collectionView.frame.height)
        
        if let scale = try? rxScale.value() {
            // use ceil to prevent gaps between cells when scaling
            width = CGFloat(ceil(self.cellWidth * scale))
        }
        
        let idx = indexPath.row
        if (isPadding(atPosition: idx)) {
            width /= 2
        }
        
        cellSize.width = width
        
        return cellSize
    }
}

protocol ChartCellProtocol {
    var CellId: String {get}
    func drawCell(rect: CGRect, data: Any)
}

extension ChartCellProtocol {
    func drawCell(rect: CGRect, data: Any) {
        // default implementation
    }
}

class BaseChartCell<T>: BaseCollectionViewCell {
    private var value: T?
    
    func setData(_ data: T) {
        self.value = data
        self.setNeedsDisplay()
    }
    
    override final func draw(_ rect: CGRect) {
        if let value = self.value,
            let c = self as? ChartCellProtocol {
            c.drawCell(rect: rect, data: value)
        }
    }
}
