//
//  DateSelectCoordinator.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/14.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class DateSelectCoordinator: ScreenCoordinator {
    let viewModel = DateSelectVM()
    
    override init(parent: ViewProtocol) {
        super.init(parent: parent)
        view = DateSelectView()
    }
    
    override func invoke() {
        // binding viewModel
        guard let v = view as? DateSelectView else { return }
        //
        v.backdrop.rx.tap.subscribe {_ in
            self.dismiss()
        }.disposed(by: v.disposeBag)
    }
}
