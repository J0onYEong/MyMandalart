//
//  SubMandaratViewControllerTransitionDelegate.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

class SubMandaratViewControllerTransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        
        switch operation {
        case .push:
            return SubMandaratPageViewController.PresentAnimation()
        case .pop:
            return SubMandaratPageViewController.DismissAnimation()
        default:
            return nil
        }
    }
}
