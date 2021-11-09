//
//  IconButton.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/24.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let DEFAULT = "TesT"

class RxIconButton: BaseComponent {
    
    fileprivate let label    = UILabel()
    fileprivate let icon     = UIImageView()
    fileprivate let ctn      = UIStackView(translate: false)
    
    fileprivate let rx_image = BehaviorSubject<UIImage?>(value: nil)
    fileprivate var rx_size: Binder<CGSize>!
    fileprivate let rx_text = BehaviorSubject<String>(value: DEFAULT)
    fileprivate var rx_font: Binder<UIFont>!
    fileprivate var rx_color: Binder<UIColor>!
    fileprivate var rx_spacing: Binder<Double>!
}

extension Reactive where Base: RxIconButton {
    var image: BehaviorSubject<UIImage?> {
        return base.rx_image
    }
    var size: Binder<CGSize> {
        return base.rx_size
    }
    var text: BehaviorSubject<String> {
        return base.rx_text
    }
    var font: Binder<UIFont> {
        return base.rx_font
    }
    var color: Binder<UIColor> {
        return base.rx_color
    }
    var spacing: Binder<Double> {
        return base.rx_spacing
    }
}

extension RxIconButton: BaseProtocol {
    @objc func setupLayout() {
        fatalError(#file + ":" + #function + " method must be overridden.")
    }
    
    @objc func bind() {
        rx_image.bind(to: icon.rx.image).disposed(by: disposeBag)
        rx_size = Binder<CGSize>(self) {view, data in
            self.icon <> {
                $0.width.equalTo(data.width)
                $0.height.equalTo(data.height)
            }
        }
        rx_text.bind(to: label.rx.text).disposed(by: disposeBag)
        rx_font = Binder<UIFont>(self) {
            self.label.font = $1
        }
        rx_color = Binder<UIColor>(self) {
            self.label.textColor = $1
        }
        rx_spacing = Binder<Double>(self) {
            self.ctn.spacing = CGFloat($1)
        }
    }
    
    func tap(closure: @escaping () -> Void) {
        let binder = Binder<UITapGestureRecognizer>(self) {_,_ in
            closure()
        }
        self
            .rx.tapGesture()
            .when(.recognized)
            .bind(to: binder)
            .disposed(by: disposeBag)
    }
    
    @objc func setupAutoLayout() {
        ctn <> {
            $0.leftMargin.top.rightMargin.bottom.equalToSuperview()
        }
    }
}

class LeftIconButton: RxIconButton {
    override func setupLayout() {
        ctn ~ {
            $0.spacing = 2
            $0.axis = .horizontal
            $0.alignment = .center
        }
        ctn ~> self
        [icon, label] ~> ctn
    }
}

class RightIconButton: RxIconButton {
    override func setupLayout() {
        ctn ~ {
            $0.spacing = 2
            $0.axis = .horizontal
            $0.alignment = .center
        }
        ctn ~> self
        [label, icon] ~> ctn
    }
}
