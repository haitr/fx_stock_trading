//
//  EnlargePresentAnimator.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/14.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class EnlargePresentAnimator: BasePresentAnimator {
    
    var initialView: UIView?
    
    init(from: UIViewController, duration: Double = 0.5, fromView: UIView? = nil) {
        initialView = fromView
        super.init(from: from, duration: duration)
    }
}

extension EnlargePresentAnimator {
    
    override func animationBuilder(
        using transitionContext: UIViewControllerContextTransitioning,
        presenting: Bool,
        targetViewController: BackDropViewProtocol,
        completion: ((Bool) -> Void)?
    ) {
        
        guard let fromView = initialView else {
            completion?(true)
            return
        }
        
        let backdrop = targetViewController.backdropView
        let mainView = targetViewController.mainView
        
        let animationTempView = UIView()
        transitionContext.containerView.insertSubview(animationTempView, at: 1)
        animationTempView ~ {
            $0.backgroundColor = mainView.backgroundColor
            $0.cornerRadius = mainView.cornerRadius
        }
        
        let window = self.vc.view.window!
        // Determine the drawer frame for both on and off screen positions.
        let fromFrame = fromView.convert(fromView.bounds, to: window)
        let toFrame = mainView.convert(mainView.bounds, to: window)
        
        let animationDuration = transitionDuration(using: transitionContext)
        let bg = backdrop.backgroundColor!

        if (presenting) {
            backdrop.backgroundColor = bg.withAlphaComponent(0)
            animationTempView ~ {
                $0.alpha = 0
                $0.frame = fromFrame
            }
            mainView ~ {
                $0.alpha = 0
            }
            // Animate the drawer sliding in and out.
            UIView.animate(withDuration: animationDuration, animations: {
                backdrop.backgroundColor = bg
                animationTempView ~ {
                    $0.alpha = 1
                    $0.frame = toFrame
                }
            }, completion: {success in
                animationTempView.removeFromSuperview()
                mainView ~ {
                    $0.alpha = 1
                }
                completion?(success)
            })
        } else {
            
            backdrop.backgroundColor = bg
            animationTempView ~ {
                $0.alpha = 1
                $0.frame = toFrame
            }
            mainView ~ {
                $0.alpha = 0
            }
            // Animate the drawer sliding in and out.
            UIView.animate(withDuration: animationDuration, animations: {
                backdrop.backgroundColor = bg.withAlphaComponent(0)
                animationTempView ~ {
                    $0.alpha = 0
                    $0.frame = fromFrame
                }
            }, completion: {success in
                animationTempView.removeFromSuperview()
                completion?(success)
            })
        }
    }
}

