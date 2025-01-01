//
//  SlidableNavigationController.swift
//  SharedPresentationExt
//
//  Created by choijunios on 1/1/25.
//

import UIKit

public class SlidableNavigationController: UINavigationController {
    
    private var duringTransition = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension SlidableNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.duringTransition = false
    }
}

extension SlidableNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer,
              let _ = topViewController else {
            return true // default value
        }
        
        return viewControllers.count > 1 && duringTransition == false
    }
}
