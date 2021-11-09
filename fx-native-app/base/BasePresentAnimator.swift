//
//  BasePresentAnimator.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/14.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

@objc protocol BackDropViewProtocol {
    var backdropView: UIView {get}
    var mainView: UIView {get}
}

class BasePresentAnimator: NSObject {
    
    // DI property
    let vc: UIViewController
    let duration: Double
    
    init(from: UIViewController, duration: Double = 0.5) {
        self.vc = from
        self.duration = duration
        super.init()
    }
}

extension BasePresentAnimator {    
    @objc func animationBuilder(
        using transitionContext: UIViewControllerContextTransitioning,
        presenting: Bool,
        targetViewController: BackDropViewProtocol,
        completion: ((Bool) -> Void)?
    ) {
        fatalError(#file + ":" + #function + " method must be overridden.")
    }
}

extension BasePresentAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension BasePresentAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Retrieve the view controllers participating in the current transition from the context.
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let fromView = fromViewController.view!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let toView = toViewController.view!
        
        // If the view to transition from is this controller's view, the drawer is being presented.
        let isPresentingDrawer = fromView == vc.view
        
        let drawerViewController = isPresentingDrawer ? toViewController : fromViewController
        let drawerView = isPresentingDrawer ? toView : fromView
        // update mainView's frame
        drawerView.layoutIfNeeded()
        
        if isPresentingDrawer {
            // Any presented views must be part of the container view's hierarchy
            transitionContext.containerView.addSubview(drawerView)
        }
        
        guard
            let bdv = drawerViewController as? BackDropViewProtocol else {
                
            if !isPresentingDrawer {
                drawerView.removeFromSuperview()
            }
                
            transitionContext.completeTransition(true)
                
            return
        }
        
        animationBuilder(
            using: transitionContext,
            presenting: isPresentingDrawer,
            targetViewController: bdv) {
                // Cleanup view hierarchy
                if !isPresentingDrawer {
                    drawerView.removeFromSuperview()
                }
                // IMPORTANT: Notify UIKit that the transition is complete.
                transitionContext.completeTransition($0)
            }
    }
}


