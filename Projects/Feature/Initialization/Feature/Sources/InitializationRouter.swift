//
//  InitializationRouter.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

class InitializationRouter: InitializationRoutable, InitializationRouting {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, interactor: InitializationInteractor) {
        
        self.navigationController = navigationController
        
        super.init(interactor: interactor)
        
        interactor.router = self
    }
}


// MARK: InitializationRouting
extension InitializationRouter {
    
    func presentMainMandaratPage() {
        
    }
    
    
    func presentNickNameInputPage() {
        
        
    }
}
