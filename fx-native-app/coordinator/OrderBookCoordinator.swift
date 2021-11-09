//
//  OrderBookCoordinator.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/14.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class OrderBookCoordinator: ScreenCoordinator {
    let viewModel = OrderBookVM()
    
    override init(parent: ViewProtocol) {
        super.init(parent: parent)
        view = OrderBookView()
    }
    
    override func invoke() {
        // binding viewModel
        guard let v = view as? OrderBookView else { return }
        //
        v.backdrop.rx.tap.subscribe {_ in
            self.dismiss()
        }.disposed(by: v.disposeBag)
    }
}
