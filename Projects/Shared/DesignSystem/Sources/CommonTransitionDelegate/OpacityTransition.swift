//
//  OpacityTransition.swift
//  SharedDesignSystem
//
//  Created by choijunios on 12/30/24.
//

import UIKit

class OpacityTransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        
        switch operation {
        case .push:
            return OpacityTransitionPresentAnimation()
        case .pop:
            return OpacityTransitionDismissAnimation()
        default:
            return nil
        }
    }
}


class OpacityTransitionPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let showing = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(showing.view)
        
        showing.view.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            
            showing.view.alpha = 1
            
        } completion: { completed in
            
            transitionContext.completeTransition(completed)
        }
    }
}

class OpacityTransitionDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let dismissing = transitionContext.viewController(forKey: .from) else { return }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            
            dismissing.view.alpha = 0
            
        } completion: { completed in
            
            dismissing.view.removeFromSuperview()
            transitionContext.completeTransition(completed)
        }
    }
}
