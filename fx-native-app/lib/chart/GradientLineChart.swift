//
//  GradientLineChart.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/11.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class GradientLineChart: BaseChart<GradientLineChartCell, DefaultChartCellDataType> {
    
    var data: DefaultChartDataType = []
    
    override func transform(data: ChartRawDataType) -> DefaultChartDataType {
        self.data = Helper.transform(data: data)
        return self.data
    }
    
    override func isPadding(atPosition: Int) -> Bool {
        return self.data[atPosition].position != .normal
    }
}

class GradientLineChartCell: BaseChartCell<DefaultChartCellDataType> {
    var aShape = UIBezierPath()
    var aPath = UIBezierPath()
    let color = UIColor.gray
    let colors = [UIColor.gray.withAlphaComponent(0.2), UIColor.clear]
}

extension GradientLineChartCell: ChartCellProtocol {
    var CellId: String {
        return "GradientLineChartCell"
    }
    
    func drawLine(rect: CGRect, data: DefaultChartCellDataType) {
        // Draw line
        aPath.removeAllPoints()
        Helper.addLine(
            aPath,
            (0, rect.height * CGFloat(1 - data.first)),
            (rect.width, rect.height * CGFloat(1 - data.second))
        )
        aPath.close()
        color.set()
        aPath.stroke()
    }
    
    func drawGradientField(rect: CGRect, data: DefaultChartCellDataType) {
        // Create shape
        aShape.removeAllPoints()
        Helper.addShape(
            aShape,
            points: [
                (0, rect.height * CGFloat(1 - data.first)),
                (rect.width, rect.height * CGFloat(1 - data.second)),
                (rect.maxX, rect.maxY),
                (rect.minX, rect.maxY)
            ]
        )
        aShape.close()
        //
        let cgColors = colors.map({ $0.cgColor })
        let startPoint = CGPoint(x: rect.width/2, y: 0)
        let endPoint = CGPoint(x: rect.width/2,y: rect.height)
        let locations: [CGFloat] = [0.0, 1.0]
        // Draw gradient onto shape
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        defer { ctx.restoreGState() }
        guard let gradient = CGGradient(colorsSpace: nil, colors: cgColors as CFArray, locations: locations) else { return }
        ctx.saveGState()
        aShape.addClip()
        ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
    
    func drawCell(rect: CGRect, data: Any) {
        guard let d = data as? DefaultChartCellDataType else {
            return
        }
        if (d.position != .normal) {
            return
        }
        drawLine(rect: rect, data: d)
        drawGradientField(rect: rect, data: d)
    }
}
