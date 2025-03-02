//
//  SceneDelegate.swift
//
//
//

import UIKit

import FeatureHome
import FeatureHomeTesting

import SharedPresentationExt
import SharedLoggerInterface

import DomainMandaratInterface
import DomainUserStateInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var rootRouter: MainMandaratRoutable?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let navigationController = NavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window = UIWindow(windowScene: windowScene)
        
    
        let component: RootComponent = .init(
            mandaratUseCase: FakeMandaratUseCase(),
            navigationController: navigationController,
            userStateUseCase: FakeUserStateUseCase(),
            logger: FakeLogger()
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
        var navigationController: NavigationControllable
        
        var userStateUseCase: UserStateUseCase
        
        var logger: Logger
    }
}

