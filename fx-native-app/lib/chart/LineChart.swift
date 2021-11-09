//
//  LineChart.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/10.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//class LineChart: BaseChart<LineChartCell, DefaultChartCellDataType> {
//    override func transform(data: RawDataType) -> DefaultChartDataType {
//        return Helper.transform(data: data)
//    }
//}
//
//class LineChartCell: BaseChartCell<DefaultChartCellDataType> {
//    override class var CellId: String {
//        return "LineChartCell"
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    var aPath = UIBezierPath()
//    let color = UIColor.gray
//    
//    func drawLine(rect: CGRect, data: DefaultChartCellDataType) {
//        // Draw line
//        aPath.removeAllPoints()
//        Helper.addLine(
//            aPath,
//            (0, rect.height * CGFloat(1 - data.first)),
//            (rect.width, rect.height * CGFloat(1 - data.second))
//        )
//        aPath.close()
//        color.set()
//        aPath.stroke()
//    }
//    
//    override func drawCell(rect: CGRect, data: DefaultChartCellDataType) {
//        if (data.first == NotDrawChartCellData || data.second == NotDrawChartCellData) {
//            return
//        }
//        drawLine(rect: rect, data: data)
//    }
//}
