//
//  BarChart.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/10.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BarChart: BaseChart<BarChartCell, DefaultChartCellDataType> {
    var data: DefaultChartDataType = []
    
    override func transform(data: ChartRawDataType) -> DefaultChartDataType {
        self.data = Helper.transform(data: data)
        return self.data
    }
    
    override func isPadding(atPosition: Int) -> Bool {
        return self.data[atPosition].position != .normal
    }
}

class BarChartCell: BaseChartCell<DefaultChartCellDataType> {
    let color = UIColor.gray
    let offset = 2.0
}

extension BarChartCell: ChartCellProtocol {
    var CellId: String {
        return "BarChartCell"
    }
    
    func drawHalfBar(rect: CGRect, data: Double, startX: Double, width: Double) {
        let startXF = CGFloat(startX)
        let dataF = CGFloat(data)
        let rec = CGRect(x: startXF,
                        y: dataF * rect.height,
                        width: CGFloat(width),
                        height: rect.height - dataF * rect.height)
        color.set()
        UIRectFill(rec)
    }
    
    func drawCell(rect: CGRect, data: Any) {
        guard let d = data as? DefaultChartCellDataType else {
            return
        }
        var width = Double(rect.width)/2 - offset/2
        switch (d.position) {
        case .first:
            // Draw 2nd bar
            width = Double(rect.width) - offset/2
            drawHalfBar(rect: rect, data: d.second, startX: offset/2, width: width)
            break
        case .last:
            // Draw 1st bar
            width = Double(rect.width)
            drawHalfBar(rect: rect, data: d.first, startX: 0.0, width: width)
            break
        default:
            // Draw 1st bar
            drawHalfBar(rect: rect, data: d.first, startX: 0.0, width: width)
            // Draw 2nd bar
            drawHalfBar(rect: rect, data: d.second, startX: Double(rect.width/2) + Double(offset)/2, width: width)
        }
    }
}
