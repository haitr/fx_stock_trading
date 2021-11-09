//
//  RxRadioWithInputButton.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/21.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxRadioWithInputButton: RxRadioButton {
    internal let textInput = TextField()
    var inputWidth = 50
}

extension RxRadioWithInputButton {
    override func bind() {
        super.bind()
        rx.state
            .map { $0 == .selected }
            .map { $0 ? self.textColorS : self.textColorU }
            .bind(to: textInput.rx.underlineColor)
            .disposed(by: disposeBag)
        rx.enable
            .map { $0 == .enabled }
            .bind(to: textInput.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    override func setupLayout() {
        ctn ~ {
            $0.spacing = 2
            $0.axis = .horizontal
            $0.alignment = .center
        }
        textInput ~ {
            $0.textAlignment = .center
        }
        ctn ~> self
        [icon, textInput, label] ~> ctn
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        textInput <> {
            $0.width.equalTo(self.inputWidth)
        }
    }
}

extension Reactive where Base: RxRadioWithInputButton {
    var textInput: ControlProperty<String?> {
        return base.textInput.rx.text
    }
}

class TextField: UITextField {
    var rx_underlineColor: Binder<UIColor> {
        return Binder<UIColor>(self) {
            self.bottomLine.backgroundColor = $1.cgColor
        }
    }
    let bottomLine = CALayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        underline()
    }
    
    private func underline() {
        if let sublayers = layer.sublayers, !sublayers.contains(bottomLine) {
            bottomLine.frame = CGRect(x: 0, y: frame.height + 1, width: frame.width, height: 1)
            borderStyle = .none
            self.layer.addSublayer(bottomLine)
        }
    }
}

extension Reactive where Base: TextField {
    var underlineColor: Binder<UIColor> {
        return base.rx_underlineColor
    }
}
