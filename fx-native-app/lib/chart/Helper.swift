//
//  Helper.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/12.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

typealias ChartRawDataType = [Double]

enum ChartCellPosition {
    case first
    case last
    case normal
}

fileprivate let NotDrawChartCellData = -Double.infinity
struct DefaultChartCellDataType {
    var first = NotDrawChartCellData
    var second = NotDrawChartCellData
    var position: ChartCellPosition = .normal
    
    init(first: Double, second: Double) {
        self.first = first
        self.second = second
    }
}
typealias DefaultChartDataType = [DefaultChartCellDataType]

class Helper: NSObject {
    static func addLine(_ path: UIBezierPath, _ from: (CGFloat, CGFloat), _ to: (CGFloat, CGFloat)) {
        path.move(to: CGPoint(x:from.0, y:from.1))
        path.addLine(to: CGPoint(x:to.0, y:to.1))
    }
    
    static func addShape(_ path: UIBezierPath, points: [(CGFloat, CGFloat)]) {
        assert(points.count > 2, "Point array must contain more than 2 points")
        path.move(to: CGPoint(x:points[0].0, y:points[0].1))
        points.forEach {
            path.addLine(to: CGPoint(x:$0.0, y:$0.1))
        }
    }
}

extension Helper{
    static func transform(data: ChartRawDataType) -> DefaultChartDataType {
        // Create tuple
        var res: DefaultChartDataType = data.enumerated().compactMap { ele in
            let index = ele.0
            if (index < data.count - 1) {
                let value = ele.1
                let first = value
                let second = data[index + 1]
                return DefaultChartCellDataType(first: first, second: second)
            }
            return nil
        }
        // first
        if var temp = res.first {
            temp.position = .first
            temp.second = temp.first
            res.insert(temp, at: 0)
        }
        
        // last
        if var temp = res.last {
            temp.position = .last
            temp.first = temp.second
            res.append(temp)
        }
        
        return res
    }
}
