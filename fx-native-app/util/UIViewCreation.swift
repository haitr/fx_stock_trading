//
//  uiview-creation.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/05.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import Foundation
import UIKit

infix operator ~
infix operator ~>

func ~<T: UIView>(left: T, _ closure: (T) -> Void) {
    closure(left)
}
func ~<T: UIView>(left: [T], _ closure: (T) -> Void) {
    left.forEach {
        closure($0)
    }
}

// Add subview of UIView
func ~><T: UIView, T1: UIView>(left: T, right: T1) {
    right.addSubview(left)
}
func ~><T: UIView, T1: UIView>(left: [T], right: T1) {
    left.forEach {
        right.addSubview($0)
    }
}

// Add subview of UIStackView
func ~><T: UIView, T1: UIStackView>(left: T, right: T1) {
    right.addArrangedSubview(left)
}
func ~><T: UIView, T1: UIStackView>(left: [T], right: T1) {
    left.forEach {
        right.addArrangedSubview($0)
    }
}

extension UILabel {
    // Short-hand init of UILabel
    static func ~(left: UILabel, _ str: String) -> UILabel {
        left.text = str
        return left
    }
}

extension UIButton {
    // Short-hand init of UIButton
    static func ~(left: UIButton, _ str: String) -> UIButton {
        left.setTitle(str, for: .normal)
        return left
    }
}

extension UIStackView {
    convenience init(translate: Bool) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = translate
    }
}
