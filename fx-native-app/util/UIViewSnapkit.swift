//
//  uiview-snapkit.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/05.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//
import SnapKit

infix operator <>

func <>(left: UIView, _ closure: (_ make: ConstraintMaker) -> Void) {
    left.snp.makeConstraints(closure)
}

func <>(left: [UIView], _ closure: (_ make: ConstraintMaker) -> Void) {
    left.forEach {
        $0.snp.makeConstraints(closure)
    }
}
