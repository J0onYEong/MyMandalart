//
//  SceneDelegate.swift
//
//
//

import UIKit

@testable import FeatureHomeTesting
@testable import FeatureHome

import SharedDependencyInjector
import SharedNavigationInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        dependencyInjection()
        
        let viewModel: HomeViewModel = .init(mandaratUseCase: MockMandaratUseCase())
        let viewController: HomeViewController = .init(reactor: viewModel)
        
        window?.rootViewController = UINavigationController()
        window?.makeKeyAndVisible()
        
        DependencyInjector.shared.resolve(Router.self).setRootModuleTo(
            module: viewController
        )
    }
    
    func dependencyInjection() {
        
        DependencyInjector.shared.assemble([
            MockAssembly()
        ])
    }
}
