//
//  SceneDelegate.swift
//
//
//

import UIKit

import FeatureHome
import FeatureHomeTesting

import DomainMandaratInterface
import DomainUserStateInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var rootRouter: MainMandaratRoutable?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window = UIWindow(windowScene: windowScene)
        
    
        let component: RootComponent = .init(
            mandaratUseCase: MockMandaratUseCase(),
            navigationController: navigationController,
            userStateUseCase: MockUserStateUseCase()
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
        var userStateUseCase: UserStateUseCase
    }
}

