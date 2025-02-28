//
//  SceneDelegate.swift
//
//
//

import UIKit

import FeatureCreateDaily

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var router: CreateDailyRoutable?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let rootComponent = RootComponent()
        let builder = CreateDailyBuilder(dependency: rootComponent)
        let router = builder.build()
        self.router = router
        
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: router.viewController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


class RootComponent: CreateDailyDependency {
    
}
