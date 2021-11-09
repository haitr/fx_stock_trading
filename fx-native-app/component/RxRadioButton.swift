//
//  RadioButton.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/16.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxRadioButton: RxLeftIconButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum SelectState {
        case selected
        case unselected
    }
    
    fileprivate var rx_state  = BehaviorRelay<SelectState>(value: .unselected)
    
    private let imageSnE: UIImage?
    private let imageSnD: UIImage?
    private let imageDefault: UIImage?
    let textColorS: UIColor // selected
    let textColorU: UIColor // unselected
    
    override init() {
        imageSnE     = Theme.radioSnE
        imageSnD     = Theme.radioSnD
        imageDefault = Theme.radioBtnDefault
        textColorS   = Theme.veryLightBlue
        textColorU   = Theme.blueGreyTwo
        super.init()
    }
}

extension Reactive where Base: RxRadioButton {
    var state: BehaviorRelay<Base.SelectState> {
        return base.rx_state
    }
}

extension RxRadioButton {
    override func bind() {
        super.bind()
        
        let state = Observable
            .combineLatest(
                rx_state.map{ $0 == .selected },
                rx.enable.map{ $0 == .enabled })
            .share()
        state
            .map { $0.0 ? self.textColorS : self.textColorU }
            .bind(to: rx.color)
            .disposed(by: disposeBag)
        state
            .map {
                if ($0.0) {
                    return $0.1 ? self.imageSnE! : self.imageSnD!
                }
                return self.imageDefault!
            }
            .bind(to: rx.image)
            .disposed(by: disposeBag)
    }
}
