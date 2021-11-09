//
//  GridX.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/16.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GridX: BaseChart<GridXCell, Bool> {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Properties
    private var step: Int
    
    init(cellWidth: Double, step: Int) {
        self.step = step
        super.init(cellWidth: cellWidth)
    }
    
    override func transform(data: ChartRawDataType) -> [Bool] {
        let res: [Bool] = data.enumerated().map { ele in
            let index = ele.0
            var res = false
            if (index % step == 0) {
                res = true
            }
            return res
        }
        return res
    }
}

class GridXCell: BaseChartCell<Bool> {
    let color = UIColor.gray.withAlphaComponent(0.5)
    let offset = 2
    
    let line = UIView()
    
    override func setData(_ data: Bool) {
        line ~ {
            $0.isHidden = !data
        }
    }
    
    override func setupLayout() {
        line ~ {
            $0.backgroundColor = color
        }
        line ~> self
    }
    
    override func setupAutoLayout() {
        line <> {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(0.5)
        }
    }
}

extension GridXCell: ChartCellProtocol {
    var CellId: String {
        return "GridXCell"
    }
}
