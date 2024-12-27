//
//  SceneDelegate.swift
//
//
//

import UIKit

import FeatureSubMandarat
import FeatureSubMandaratTesting

import DomainMandaratInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var router: SubMandaratPageRoutable!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController: UINavigationController = .init()
        
        let component = RootComponent(
            mandaratUseCase: MockMandaratUseCase(),
            navigationController: navigationController
        )
        
        self.router = SubMandaratPageBuilder(dependency: component)
            .build(mainMandaratVO: .mock)
        
        navigationController.viewControllers = [ router.viewController ]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    struct RootComponent: SubMandaratPageDependency {
        var mandaratUseCase: MandaratUseCase
        var navigationController: UINavigationController
    }
}
