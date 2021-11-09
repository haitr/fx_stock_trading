//
//  SelectButton.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/24.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PopoverSwift

extension Reactive where Base: SelectButton {
    var open: BehaviorSubject<Bool> {
        return base.rx_open
    }
    var title: BehaviorSubject<String> {
        return base.rx_title
    }
}

class SelectButton: RxRightIconButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var owner: UIViewController!
    private var menu: PopoverController!
    
    fileprivate var rx_open     = BehaviorSubject<Bool>(value   : false)
    fileprivate var rx_title    = BehaviorSubject<String>(value : "test")
    fileprivate var rx_data     = PublishSubject<[String:String]>()
    fileprivate var rx_selected = PublishSubject<String>()
    
    init(of: UIViewController) {
        super.init()
        owner = of
    }
}

extension SelectButton {
    override func bind() {
        super.bind()
        
        rx_title
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.rx.text)
            .disposed(by: disposeBag)
        rx_open
            .map{ $0 ? "chevron.up" : "chevron.down" }
            .map{ UIImage(systemName: $0) }
            .asDriver(onErrorJustReturn: UIImage())
            .drive(self.rx.image)
            .disposed(by: disposeBag)
        self
            .rx.tapGesture()
            .skipUntil(rx_data)
            .when(.recognized)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { _ in
                self.openMenu()
            }
            .disposed(by: disposeBag)
        
        observePopover()
    }
    
    override func setupLayout() {
        super.setupLayout()
    }
    
    override func setupAutoLayout() {
        self ~ {
            $0.layoutMargins = UIEdgeInsets.zero
        }
        super.setupAutoLayout()
    }
    
    private func observePopover() {
        rx_data
            .map {
                $0.compactMap { item in
                    PopoverItem(title: item.value) {_ in
                        self.menuSelect(key: item.key)
                    }
                }
            }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: {
                self.menu = PopoverController(items: $0, fromView: self)
                self.menu.coverColor = UIColor.black
                self.menu.textColor = UIColor.white
            })
            .disposed(by: disposeBag)
    }
}

extension SelectButton {
    private func menuSelect(key: String) {
        print(key)
    }
    
    private func openMenu() {
        owner.popover(menu)
    }
}
