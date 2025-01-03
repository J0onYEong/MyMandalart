//
//  SceneDelegate.swift
//
//
//

import UIKit

import FeatureSubMandarat
import FeatureSubMandaratTesting

import SharedLoggerInterface
import SharedPresentationExt

import DomainMandaratInterface
import DomainUserStateInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var router: SubMandaratPageRoutable!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController: NavigationController = .init()
        navigationController.isNavigationBarHidden = true
        
        let component = RootComponent(
            mandaratUseCase: FakeMandaratUseCase(),
            userStateUseCase: FakeUserStateUseCase(),
            navigationController: navigationController,
            logger: FakeLogger()
        )
        
        self.router = SubMandaratPageBuilder(dependency: component)
            .build(mainMandaratVO: .stub)
        
        navigationController.viewControllers = [ router.viewController ]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    struct RootComponent: SubMandaratPageDependency {

        var mandaratUseCase: MandaratUseCase
        var userStateUseCase: UserStateUseCase
        
        var navigationController: NavigationControllable
        
        var logger: Logger
    }
}
