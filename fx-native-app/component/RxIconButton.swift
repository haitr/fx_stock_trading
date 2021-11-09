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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum EnableState {
        case enabled
        case disabled
    }
    
    internal let label    = UILabel()
    internal let icon     = UIImageView()
    internal let ctn      = UIStackView(translate: false)
    
    fileprivate let rx_image = BehaviorSubject<UIImage?>(value: nil)
    fileprivate var rx_size: Binder<CGSize>!
    fileprivate let rx_text = BehaviorSubject<String>(value: DEFAULT)
    fileprivate var rx_font: Binder<UIFont>!
    fileprivate var rx_color: Binder<UIColor>!
    fileprivate var rx_spacing: Binder<Double>!
    fileprivate var rx_tap: Observable<RxIconButton>!
    fileprivate var rx_enable = BehaviorRelay<EnableState>(value: .enabled)
    
    init() {
        super.init(frame: CGRect.zero)
        self.layoutMargins = .zero
    }
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
    var tap: Observable<RxIconButton> {
        return base.rx_tap
    }
    var enable: BehaviorRelay<Base.EnableState> {
        return base.rx_enable
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
        rx_tap = self.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(rx_enable)
            .filter { $0 == .enabled }
            .map{ _ in self }
    }
    
    @objc func setupAutoLayout() {
        ctn <> {
            $0.leftMargin.top.rightMargin.bottom.equalToSuperview()
        }
    }
}

class RxLeftIconButton: RxIconButton {
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

class RxRightIconButton: RxIconButton {
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
