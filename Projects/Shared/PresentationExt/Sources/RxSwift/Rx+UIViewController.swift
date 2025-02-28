//
//  Rx+UIViewController.swift
//  SharedPresentationExt
//
//  Created by choijunios on 12/31/24.
//

import UIKit

import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var deviceMode: Observable<UIViewController.DeviceMode> {
        base.deviceMode
    }
}


// MARK: Device screen mode
public extension UIViewController {
    
    enum DeviceMode {
        case portrait, landscape
    }
    
    internal var deviceMode: Observable<DeviceMode> {
        
        self.rx.viewWillLayoutSubviews
            .compactMap { _ in
                
                let deviceOrientation = UIDevice.current.orientation
                
                switch deviceOrientation {
                case .portrait:
                    
                    return .portrait
                    
                case .landscapeRight, .landscapeLeft:
                    
                    return .landscape
                    
                default:
                    return nil
                }
                
            }
    }
}
