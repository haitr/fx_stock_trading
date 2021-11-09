//
//  PlaceholderView.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/06.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class PlaceholderView: BaseComponent {    
    lazy var color = UIColor.gray
    lazy var lbl = UILabel() ~ "Placeholder"
    
    convenience init(_ name: String, stroke color: UIColor = UIColor.gray) {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.color = color
        lbl ~ {
            $0.text = name
            $0.textColor = color
        }
    }
    
    func addLine(_ aPath: UIBezierPath, _ from: (CGFloat, CGFloat), _ to: (CGFloat, CGFloat)) {
        aPath.move(to: CGPoint(x:from.0, y:from.1))
        aPath.addLine(to: CGPoint(x:to.0, y:to.1))
    }
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        addLine(aPath, (rect.minX, rect.minY), (rect.minX, rect.maxY))
        addLine(aPath, (rect.minX, rect.minY), (rect.maxX, rect.maxY))
        addLine(aPath, (rect.minX, rect.minY), (rect.maxX, rect.minY))
        addLine(aPath, (rect.minX, rect.maxY), (rect.maxX, rect.minY))
        addLine(aPath, (rect.minX, rect.maxY), (rect.maxX, rect.maxY))
        addLine(aPath, (rect.maxX, rect.minY), (rect.maxX, rect.maxY))
        aPath.close()
        color.set()
        aPath.stroke()
    }
}

extension PlaceholderView: BaseProtocol {
    func setupLayout() {
        addSubview(lbl)
    }
    
    func setupAutoLayout() {
        lbl <> {
            $0.center.equalToSuperview()
        }
    }
    
}
