//
//  GridY.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/17.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift

class GridY: BaseComponent {
    required init?(coder: NSCoder) {
        fatalError(#file + ":" + #function + " method must be overridden.")
    }
    
    // Properties
    var step: Int
    var color = UIColor.gray.withAlphaComponent(0.5)
    
    private var cells: [GridYCell]
    
    init(step: Int) {
        self.step = step
        self.cells = [GridYCell]()
        for _ in 0..<step {
            self.cells.append(GridYCell(color: color))
        }
        super.init(frame: CGRect.zero)
    }
}

extension GridY: BaseProtocol {
    func setupLayout() {
        cells ~> self
    }
    
    func setupAutoLayout() {
        cells <> {
            $0.left.right.equalToSuperview()
        }
        if let first = cells.first {
            first <> {
                $0.top.equalToSuperview()
            }
        }
        if let last = cells.last {
            last <> {
                $0.bottom.equalToSuperview()
            }
        }
        for (index, cell) in cells[1...].enumerated() {
            cell <> {
                $0.top.equalTo(cells[index].snp.bottom)
                $0.height.equalTo(cells[index].snp.height)
            }
        }
    }
}

class GridYCell: BaseComponent {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var color: UIColor
    
    let line = UIView()
    let text = UILabel()
    
    init(color: UIColor) {
        self.color = color
        super.init(frame: CGRect.zero)
    }
}

extension GridYCell: BaseProtocol {
    func setupLayout() {
        line ~ {
            $0.backgroundColor = color
        }
        line ~> self
    }
    
    func setupAutoLayout() {
        line <> {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
