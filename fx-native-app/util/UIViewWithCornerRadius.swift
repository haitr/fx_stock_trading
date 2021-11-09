//
//  UIViewWithCornerRadius.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/31.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

extension UIView {
    
    var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            self.layer.cornerRadius
        }
    }
    
    func borderColor(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
    }

    func borderWidth(_ width: CGFloat) {
        self.layer.borderWidth = width
    }
}
