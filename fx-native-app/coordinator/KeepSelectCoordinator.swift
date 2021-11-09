//
//  KeepSelectCoordinator.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/20.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class KeepSelectCoordinator: ScreenCoordinator {
    let viewModel = KeepSelectVM()
    
    override init(parent: ViewProtocol) {
        super.init(parent: parent)
        view = KeepSelectView()
    }
    
    override func invoke() {
        // binding viewModel
        guard let v = view as? KeepSelectView else { return }
        //
        v.backdrop.rx.tap.subscribe {_ in
            self.dismiss()
        }.disposed(by: v.disposeBag)
    }
}
