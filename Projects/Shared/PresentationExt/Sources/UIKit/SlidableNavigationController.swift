//
//  SlidableNavigationController.swift
//  SharedPresentationExt
//
//  Created by choijunios on 1/1/25.
//

import UIKit

public protocol NavigationControllable: UINavigationController {
    
    func enableSlidePop()
    
    func disableSlidePop()
    
    var isSlidable: Bool { get }
}


public class NavigationController: UINavigationController, NavigationControllable, UINavigationControllerDelegate {
    
    public private(set) var isSlidable: Bool = false
    
    private lazy var gestureDelegate = NavigationControllerGestureRecognizerDelegate(nav: self)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = gestureDelegate
    }
}


// MARK: NavigationControllerGestureRecognizerDelegate
class NavigationControllerGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    weak var nav: NavigationControllable!
    
    init(nav: NavigationControllable!) {
        self.nav = nav
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard gestureRecognizer == nav.interactivePopGestureRecognizer,
              let _ = nav.topViewController else {
            
            return true
        }
        
        return nav.viewControllers.count > 1 && nav.isSlidable == true
    }
}


// MARK: SlidableController
public extension NavigationController {
    
    func enableSlidePop() {
        isSlidable = true
    }
    
    func disableSlidePop() {
        isSlidable = false
    }
}
