//
//  BottomUpAnimation.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/10.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class PartialPresentAnimator: BasePresentAnimator {
    
    enum Direction {
        case bottom
        case right
    }
    
    private let direction: Direction
    
    init(from: UIViewController, direction: Direction, duration: Double = 0.5) {
        self.direction = direction
        super.init(from: from, duration: duration)
    }
}

extension PartialPresentAnimator {
    private func offScreenFrame(container: CGRect, target: CGRect) -> CGRect {
        let size = target.size
        var origin = CGPoint.zero
        switch direction {
        case .bottom:
            origin = CGPoint(x: 0, y: container.height)
            break
        case .right:
            origin = CGPoint(x: container.width, y: 0)
            break
        }
        return CGRect(origin: origin, size: size)
    }
    
    override func animationBuilder(
        using transitionContext: UIViewControllerContextTransitioning,
        presenting: Bool,
        targetViewController: BackDropViewProtocol,
        completion: ((Bool) -> Void)?
    ) {
        let targetFrame = transitionContext.containerView.frame
        let backdrop = targetViewController.backdropView
        let mainView = targetViewController.mainView
        let mainFrame = mainView.frame
        let bg = backdrop.backgroundColor!
        
        // Determine the drawer frame for both on and off screen positions.
        let offScreenDrawerFrame = offScreenFrame(container: targetFrame, target: mainFrame)
        
        let onScreenDrawerFrame = mainFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        if (presenting) {
            backdrop.backgroundColor = bg.withAlphaComponent(0)
            mainView.frame = offScreenDrawerFrame
            // Animate the drawer sliding in and out.
            UIView.animate(withDuration: animationDuration, animations: {
                backdrop.backgroundColor = bg
                mainView.frame = onScreenDrawerFrame
            }, completion: { (success) in
                // IMPORTANT: Notify UIKit that the transition is complete.
                transitionContext.completeTransition(success)
            })
        } else {
            backdrop.backgroundColor = bg
            mainView.frame = onScreenDrawerFrame
            // Animate the drawer sliding in and out.
            UIView.animate(withDuration: animationDuration, animations: {
                backdrop.backgroundColor = bg.withAlphaComponent(0)
                mainView.frame = offScreenDrawerFrame
            }, completion: completion)
        }
    }
}

