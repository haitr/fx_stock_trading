//
//  AxisX.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/12.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AxisX: BaseChart<AxisXCell, String> {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Properties
    private var step: Int
    
    init(cellWidth: Double, step: Int) {
        self.step = step
        super.init(cellWidth: cellWidth)
    }
    
    override func transform(data: ChartRawDataType) -> [String] {
        let res: [String] = data.enumerated().map { ele in
            let index = ele.0
            var res = ""
            if (index % step == 0) {
                res = "\(index)"
            }
            return res
        }
        return res
    }
}

class AxisXCell: BaseChartCell<String> {
    lazy var label = UILabel()
    let color = UIColor.gray
    let offset = 2
    
    override func setData(_ data: String) {
        label ~ {
            $0.text = data
        }
    }
    
    override func setupLayout() {
        label ~ {
            $0.textColor = UIColor.white
            $0.font = UIFont.systemFont(ofSize: 10)
            $0.sizeToFit()
        }
        label ~> self
    }
    
    override func setupAutoLayout() {
        label <> {
            $0.center.equalToSuperview()
        }
    }
}

extension AxisXCell: ChartCellProtocol {
    var CellId: String {
        return "AxisXCell"
    }
}
