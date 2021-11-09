//
//  RoundedButotn.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/02.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyButton: UIButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var mapColor: [UInt:UIColor] = [:]
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        binding()
    }
    
    private var rx_state: BehaviorRelay<UIControl.State>!
    private var disposeBag = DisposeBag()
    
    private func binding() {
        mapColor[UIControl.State.normal.rawValue] = backgroundColor ?? UIColor.clear
        rx_state = BehaviorRelay<UIControl.State>(value: .normal)
        rx_state
            .map {
                self.mapColor[$0.rawValue] ??
                self.mapColor[UIControl.State.normal.rawValue]!
            }
            .bind(to: self.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    override var isHighlighted: Bool {
        get { super.isHighlighted }
        
        set {
            if (newValue) {
                rx_state.accept(.highlighted)
            }
            super.isHighlighted = newValue
        }
    }
    
    override var isEnabled: Bool {
        get { super.isEnabled }
        
        set {
            if (newValue) {
                rx_state.accept(.normal)
            } else {
                rx_state.accept(.disabled)
            }
            super.isEnabled = newValue
        }
    }
    
    override var isSelected: Bool {
        get { super.isSelected }
        
        set {
            if (newValue) {
                rx_state.accept(.selected)
            }
            super.isSelected = newValue
        }
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        mapColor[state.rawValue] = color
    }
}
