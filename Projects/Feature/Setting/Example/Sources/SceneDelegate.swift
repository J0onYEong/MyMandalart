//
//  SceneDelegate.swift
//
//
//

import UIKit

import FeatureSetting
import FeatureSettingTesting
import DomainUserStateInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate, SettingPageViewModelListener {
    
    var window: UIWindow?
    
    var router: SettingPageRoutable!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let navigationController: UINavigationController = .init()
        navigationController.isNavigationBarHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let rootComponent = RootComponent(
            userStateUseCase: MockUserStateUseCase(),
            navigationController: navigationController
        )
        
        router = SettingPageBuilder(dependency: rootComponent)
            .build(interactorListener: self)
        
        let viewController = router.viewController
        navigationController.viewControllers = [viewController]
    }
    
    struct RootComponent: SettingPageDependency {
        
        var userStateUseCase: UserStateUseCase
        var navigationController: UINavigationController
    }
}


// MARK: SettingPageViewModelListener
extension SceneDelegate {
    
    func nickNameUpdated(_ nickName: String) {
        
        print("SceneDelegate: 닉네임 업데이트 전달됨 : \(nickName)")
    }
    
    func settingPageFinished() {
        
        print("세팅화면 종료")
    }
}
