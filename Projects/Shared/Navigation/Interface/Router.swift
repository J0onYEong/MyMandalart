//
//  Router.swift
//  Navigation
//
//  Created by choijunios on 12/10/24.
//

import UIKit

private protocol RouteProtocol {
    
    var topViewController: UIViewController? { get }
    
    
    func present(_ module: UIViewController, animated: Bool, modalPresentationSytle: UIModalPresentationStyle)
    
    
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    
    func push(_ module: UIViewController, animated: Bool)
    
    
    func push(_ module: UIViewController, animated: Bool, delegate: UINavigationControllerDelegate)
    
    
    func pop(animated: Bool)
    
    
    func pop(animated: Bool, delegate: UINavigationControllerDelegate)
    
    
    func setRootModuleTo(module: UIViewController)
}

public final class Router: NSObject, RouteProtocol {
    
    private weak var rootController: UINavigationController?
    
    /// 네비게이션 최상단 ViewController
    fileprivate var topViewController: UIViewController? {
        rootController?.topViewController
    }
    
    
    public override init() {
        super.init()
    }
    
    
    public func present(_ module: UIViewController, animated: Bool, modalPresentationSytle: UIModalPresentationStyle) {
        
        module.modalPresentationStyle = modalPresentationSytle
        
        rootController?.present(
            module,
            animated: animated
        )
    }
    
    
    public func dismissModule(animated: Bool, completion: (() -> Void)? = nil) {
        
        rootController?.dismiss(
            animated: animated,
            completion: completion
        )
    }
    
    
    public func push(_ module: UIViewController, animated: Bool) {
        
        guard (module is UINavigationController) == false else {
            return assertionFailure("\(#function) 네비게이션 컨트롤러 삽입 불가")
        }
        
        rootController?.pushViewController(
            module,
            animated: animated
        )
    }
    
    
    public func push(_ module: UIViewController, animated: Bool, delegate: any UINavigationControllerDelegate) {
        
        rootController?.delegate = delegate
        push(module, animated: animated)
        rootController?.delegate = nil
    }
    
    
    public func push(module: UIViewController, to: UINavigationController, animated: Bool) {
        
        to.pushViewController(module, animated: animated)
    }
    
    
    public func pop(animated: Bool) {
        rootController?.popViewController(animated: animated)
    }
    
    
    public func pop(animated: Bool, delegate: any UINavigationControllerDelegate) {
        
        rootController?.delegate = delegate
        pop(animated: animated)
        rootController?.delegate = nil
    }
    
    
    public func changeRootModuleTo(module: UIViewController, animated: Bool) {
        
        rootController?.setViewControllers([module], animated: animated)
    }

    
    public func setRootModuleTo(module: UIViewController) {
        guard let keyWindow = UIWindow.keyWindow else { return }
        let navigationController = UINavigationController(rootViewController: module)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        keyWindow.rootViewController = navigationController
        
        self.rootController = navigationController
    }
}

extension UIWindow {
    
    static var keyWindow: UIWindow? {
        
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            return keyWindow
        }
        return nil
    }
}
