//
//  Segment.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/26.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SegmentButton: UIButton {
    var rx_selectedColor: Binder<UIColor>!
    var rx_normalColor  : Binder<UIColor>!
    var rx_selectedFont : Binder<UIFont>!
    var rx_normalFont   : Binder<UIFont>!
    
    private func binding() {
        rx_selectedColor = Binder(self) { view, data in
            view.setTitleColor(data, for: .selected)
        }
        rx_normalColor = Binder(self) { view, data in
            view.setTitleColor(data, for: .normal)
        }
        rx_selectedFont = Binder(self) { view, data in
            if (view.isSelected) {
                view.titleLabel?.font = data
            }
        }
        rx_normalFont = Binder(self) { view, data in
            if (!view.isSelected) {
                view.titleLabel?.font = data
            }
        }
    }
}

extension SegmentButton {
    static func create(title: String) -> SegmentButton {
        let res = SegmentButton(type: .custom)
        res.setTitle(title, for: .normal)
        res.binding()
        return res
    }
}

struct SegmentButtonInfo {
    var key: String!
    var title: String!
}

class Segment: BaseComponent {
    //
    private lazy var btns : [SegmentButton]          = []
    private lazy var mapBtn : [String:SegmentButton] = [:]
    private lazy var underline                       = UIView()
    
    // Properties
    fileprivate var rx_data         : Binder<[SegmentButtonInfo]>!
    fileprivate let rx_selected     = ReplaySubject<String>.create(bufferSize : 1)
    var minWidth        = 50
    var underlineHeight = 2
    var spacing         = 0
    
    fileprivate var rx_activeColor   = BehaviorSubject<UIColor>(value: UIColor.red)
    fileprivate var rx_activeFont    = BehaviorSubject<UIFont> (value: UIFont.boldSystemFont(ofSize: 14))
    fileprivate var rx_inactiveColor = BehaviorSubject<UIColor>(value: UIColor.white)
    fileprivate var rx_inactiveFont  = BehaviorSubject<UIFont> (value: UIFont.systemFont(ofSize: 14))
}

extension Reactive where Base: Segment {
    var data: Binder<[SegmentButtonInfo]> {
        return base.rx_data
    }
    var selected: ReplaySubject<String> {
        return base.rx_selected
    }
    var activeColor: BehaviorSubject<UIColor> {
        return base.rx_activeColor
    }
    var activeFont: BehaviorSubject<UIFont> {
        return base.rx_activeFont
    }
    var inactiveColor: BehaviorSubject<UIColor> {
        return base.rx_inactiveColor
    }
    var inactiveFont: BehaviorSubject<UIFont> {
        return base.rx_inactiveFont
    }
}

extension Segment: BaseProtocol {
    func bind() {
        rx_activeColor.bind(to: underline.rx.backgroundColor).disposed(by: disposeBag)
        
        rx_data = Binder(self) { view, data in
            self.removeAllButtons()
            data.forEach {info in
                let btn = SegmentButton.create(title: info.title)
                self.rx_activeColor
                    .bind(to: btn.rx_selectedColor)
                    .disposed(by: self.disposeBag)
                self.rx_inactiveColor
                    .bind(to: btn.rx_normalColor)
                    .disposed(by: self.disposeBag)
                self.rx_activeFont
                    .bind(to: btn.rx_selectedFont)
                    .disposed(by: self.disposeBag)
                self.rx_inactiveFont
                    .bind(to: btn.rx_normalFont)
                    .disposed(by: self.disposeBag)
                btn.rx.tap
                    .map { info.key }
                    .bind(to: view.rx_selected)
                    .disposed(by: view.disposeBag)
                self.btns.append(btn)
                self.mapBtn[info.key] = btn
            }
            self.addButtons()
            self.placeButtons()
        }
        
        rx_selected
            .subscribe {
                guard let key = $0.element else {
                    return
                }
                // btn.isSelected somehow affects the constraint (Auto-Layout)
                // so I called update constraint before change isSelected state change
                self.updateUnderline(toKey: key)
                self.activeButton(key: key)
            }
            .disposed(by: disposeBag)
    }
    
    func setupLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        //
        underline ~> self
        //
        resetUnderlineLayout()
    }
    
    func setupAutoLayout() {
        //
    }
    
    private func activeButton(key: String) {
        btns.forEach {
            $0.isSelected = false
        }
        if let btn = mapBtn[key] {
            btn.isSelected = true
        }
    }
    
    private func resetUnderlineLayout() {
        underline <> {
            $0.left.bottom.equalToSuperview()
            $0.height.equalTo(2)
            $0.width.equalTo(0)
        }
    }
    
    private func updateUnderline(toKey: String) {
        guard let btn = mapBtn[toKey] else {
            resetUnderlineLayout()
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.underline.snp.remakeConstraints {
                // remakeConstraints gonna remove all current constraints at first
                $0.left.right.equalTo(btn)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(2)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func removeAllButtons() {
        btns.forEach{ $0.removeFromSuperview() }
    }
    
    private func addButtons() {
        // Add buttons to container
        btns ~> self
    }
    
    private func placeButtons() {
        btns <> {
            $0.width.equalTo(minWidth).priority(.medium)
            $0.top.bottom.equalToSuperview()
        }
        for idx in 1..<btns.count {
            btns[idx] <> {
                $0.left.equalTo(btns[idx-1].snp.right).offset(spacing)
            }
        }
        if let btn = btns.first {
            btn <> {
                $0.left.equalToSuperview()
            }
        }
        if let btn = btns.last {
            btn <> {
                $0.right.equalToSuperview()
            }
        }
    }
}
