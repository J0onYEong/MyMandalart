//
//  SceneDelegate.swift
//
//
//

import UIKit

import FeatureHome
import FeatureHomeTesting

import DomainMandaratInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var rootRouter: MainMandaratRoutable?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let navigationController = UINavigationController()
        
        window = UIWindow(windowScene: windowScene)
        
    
        let component: RootComponent = .init(
            mandaratUseCase: MockMandaratUseCase(),
            navigationController: navigationController
        )
        
        let router = MainMandaratBuilder(dependency: component).build()
        self.rootRouter = router
        
        navigationController.viewControllers = [
            router.viewController
        ]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    struct RootComponent: MainMandaratDependency {
        
        var mandaratUseCase: MandaratUseCase
        var navigationController: UINavigationController
    }
}

