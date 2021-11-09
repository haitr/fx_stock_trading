//
//  Coordinator.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/23.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

protocol ViewProtocol {
    var interface: UIViewController? { get }
}

// MARK: - Router
protocol RouterProtocol {
    func push(coordinator: ViewProtocol, animated: Bool)
    func pop(animated: Bool)
}

class BaseRouter: NSObject {
    var navigationController: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
        super.init()
        navigationController.delegate = self
    }
    
    private func executeClosure(_ previousVC: UIViewController) {
        
    }
    
}

extension BaseRouter: RouterProtocol {
    func push(coordinator: ViewProtocol, animated: Bool = true) {
        guard let vc = coordinator.interface else {
            return
        }
        navigationController.pushViewController(vc, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}

extension BaseRouter: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Execute closure on dismiss
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController) else {
                return
        }
        executeClosure(previousController)
    }
}

extension BaseRouter: ViewProtocol {
    var interface: UIViewController? {
        return navigationController
    }
}

class NavigationController : UINavigationController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarStyle
        }
        return .default
    }
}

// MARK: - Coordinator
protocol CoordinatorProtocol : class {
    var childCoordinators : [CoordinatorProtocol] { get set }
    func invoke()
}

extension CoordinatorProtocol {
    func store(coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

class BaseCoordinator: NSObject, CoordinatorProtocol, ViewProtocol {
    var childCoordinators : [CoordinatorProtocol] = []
    var isCompleted: (() -> ())?
    
    var parent: ViewProtocol?
    
    func invoke() {
        fatalError(#file + ":" + #function + " method must be overridden.")
    }
    
    var interface: UIViewController? {
        fatalError(#file + ":" + #function + " method must be overridden.")
    }
}

class ScreenCoordinator: BaseCoordinator {
    var view: UIViewController!
    var presenting: UIViewController?
    
    override var interface: UIViewController? {
        return view
    }
    
    init(parent: ViewProtocol) {
        super.init()
        self.parent = parent
    }
}

extension ScreenCoordinator: RouterProtocol {
    func push(coordinator: ViewProtocol, animated: Bool) {
        guard let v = coordinator.interface else {
            return
        }
        presenting = v
        view.present(v, animated: animated, completion: nil)
    }
    
    func pop(animated: Bool) {
        presenting?.dismiss(animated: animated, completion: nil)
    }
}

extension ScreenCoordinator {
    func dismiss() {
        guard let parent = parent as? ScreenCoordinator else {
            return
        }
        parent.pop(animated: true)
    }
}
