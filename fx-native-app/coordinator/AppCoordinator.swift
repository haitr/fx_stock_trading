//
//  AppCoordinator.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/23.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class AppCoordinator<T: UIViewController>: BaseCoordinator {
    
    // MARK: - Properties
    let window: UIWindow?

    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
    }

    override func invoke() {
        guard let window = window else {
            return
        }
        let root = BaseRouter(navigation: NavigationController())
        let mainCoordinator = MainCoordinator(parent: root)
        mainCoordinator.invoke()
        window.rootViewController = root.interface
        window.makeKeyAndVisible()
        root.push(coordinator: mainCoordinator, animated: true)
        //
    }

}
