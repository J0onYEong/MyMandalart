//
//  InitializationRouter.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import FeatureHome

class InitializationRouter: InitializationRoutable, InitializationRouting {
    
    private let mainMandaratPageBuilder: MainMandaratBuilder
    
    private let navigationController: UINavigationController
    
    init(
        mainMandaratPageBuilder: MainMandaratBuilder,
        navigationController: UINavigationController,
        interactor: InitializationInteractor) {
        
        self.mainMandaratPageBuilder = mainMandaratPageBuilder
        self.navigationController = navigationController
        
        super.init(interactor: interactor)
        
        interactor.router = self
    }
}


// MARK: InitializationRouting
extension InitializationRouter {
    
    func presentMainMandaratPage() {
        
        let router = mainMandaratPageBuilder.build()
        
        let viewController = router.viewController
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
    func presentNickNameInputPage() {
        
    }
}
