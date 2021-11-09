//
//  MainCoordinator.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/23.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class MainCoordinator: ScreenCoordinator {
    let viewModel = MainVM()
    
    private var settingAnimation: PartialPresentAnimator?
    private var orderBookAnimation: PartialPresentAnimator?
    private var tempAnimation: EnlargePresentAnimator?
    
    override init(parent: ViewProtocol) {
        super.init(parent: parent)
        let v = MainView()
        self.view = v
        if let pr = parent.interface {
            settingAnimation = PartialPresentAnimator(from: pr, direction: .bottom, duration: 0.2)
            orderBookAnimation = PartialPresentAnimator(from: pr, direction: .right, duration: 0.2)
            tempAnimation = EnlargePresentAnimator(from: pr, duration: 0.2, fromView: v.autoUpdateBtn)
        }
    }
    
    override func invoke() {
        // binding viewModel
        guard let v = view as? MainView else { return }
        v.settingBtn.rx.tap.subscribe {_ in
            self.openSetting()
        }.disposed(by: v.disposeBag)
        v.orderBookBtn.rx.tap.subscribe {_ in
            self.openOrderBook()
        }.disposed(by: v.disposeBag)
    }
}

// Custom navigator
extension MainCoordinator {
    func openSetting() {
        let coor = SettingCoordinator(parent: self)
        coor.invoke()
        guard let v = coor.interface else {
            return
        }
        v.modalPresentationStyle = .custom
        v.transitioningDelegate = settingAnimation
        self.push(coordinator: coor, animated: true)
    }
    
    private func openOrderBook() {
        let coor = OrderBookCoordinator(parent: self)
        coor.invoke()
        guard let v = coor.interface else {
            return
        }
        v.modalPresentationStyle = .custom
        v.transitioningDelegate = orderBookAnimation
        self.push(coordinator: coor, animated: true)
    }
}
