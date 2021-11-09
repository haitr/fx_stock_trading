//
//  SettingCoordinator.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/08.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class SettingCoordinator: ScreenCoordinator {
    let viewModel = MainVM()
    
    private var enlargeAnimation: EnlargePresentAnimator?
    
    override init(parent: ViewProtocol) {
        super.init(parent: parent)
        let v = SettingView()
        self.view = v
        enlargeAnimation = EnlargePresentAnimator(from: v, duration: 0.3)
    }
    
    override func invoke() {
        // binding viewModel
        guard let v = view as? SettingView else { return }
        //
        v.backdrop.rx.tap.subscribe {_ in
            self.dismiss()
        }.disposed(by: v.disposeBag)
        //
        v.closeBtn.rx.tap.subscribe{_ in
            self.dismiss()
        }.disposed(by: v.disposeBag)
        //
        v.dateBtn.rx.tap.subscribe {_ in
            self.openDateSelect()
        }.disposed(by: v.disposeBag)
        v.keepBtn.rx.tap.subscribe {_ in
            self.openKeepSelect()
        }.disposed(by: v.disposeBag)
        v.sellBtn.rx.tap.subscribe {_ in
            self.openSellSelect()
        }.disposed(by: v.disposeBag)
    }
}

// Custom navigator
extension SettingCoordinator {
    func openDateSelect() {
        let coor = DateSelectCoordinator(parent: self)
        coor.invoke()
        guard let v = coor.interface else {
            return
        }
        v.modalPresentationStyle = .custom
        enlargeAnimation?.initialView = (view as! SettingView).dateBtn
        v.transitioningDelegate = enlargeAnimation
        self.push(coordinator: coor, animated: true)
    }
    
    private func openKeepSelect() {
        let coor = KeepSelectCoordinator(parent: self)
        coor.invoke()
        guard let v = coor.interface else {
            return
        }
        v.modalPresentationStyle = .custom
        enlargeAnimation?.initialView = (view as! SettingView).keepBtn
        v.transitioningDelegate = enlargeAnimation
        self.push(coordinator: coor, animated: true)
    }

    private func openSellSelect() {
        let coor = SellSelectCoordinator(parent: self)
        coor.invoke()
        guard let v = coor.interface else {
            return
        }
        v.modalPresentationStyle = .custom
        enlargeAnimation?.initialView = (view as! SettingView).sellBtn
        v.transitioningDelegate = enlargeAnimation
        self.push(coordinator: coor, animated: true)
    }
}
