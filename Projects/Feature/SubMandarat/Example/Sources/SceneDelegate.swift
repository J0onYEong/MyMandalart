//
//  SceneDelegate.swift
//
//
//

import UIKit

import FeatureSubMandarat
import FeatureSubMandaratInterface
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
            navigationController: navigationController,
            mainMandaratVO: .mock
        )
        
        self.router = SubMandaratPageBuilder(dependency: component).build()
        navigationController.viewControllers = [ router.viewController ]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    struct RootComponent: SubMandaratPageDependency {
        var mandaratUseCase: MandaratUseCase
        var navigationController: UINavigationController
        var mainMandaratVO: MainMandaratVO
    }
}
