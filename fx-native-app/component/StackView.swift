//
//  StackView.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/03.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import SnapKit

// Why:
// I need UIView's properties and margins
class StackView: BaseComponent {
    
    enum Placement {
        case normal
        case centerX
        case centerY
    }
    
    private var innerStack = UIStackView(translate: false)
    
    var stack: UIStackView {
        get { innerStack }
    }
    
    var placement: Placement = .normal
    
    override func addSubview(_ view: UIView) {
        innerStack.addArrangedSubview(view)
    }
}

extension StackView: BaseProtocol {
    func setupLayout() {
        super.addSubview(innerStack)
    }
    
    func setupAutoLayout() {
        switch (placement) {
        case .centerX:
            innerStack.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.topMargin.bottomMargin.equalToSuperview()
            }
            break
        case .centerY:
            innerStack.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.leftMargin.rightMargin.equalToSuperview()
            }
            break
        default:
            innerStack.snp.remakeConstraints {
                $0.leftMargin.topMargin.rightMargin.bottomMargin.equalToSuperview()
            }
        }
    }
}
