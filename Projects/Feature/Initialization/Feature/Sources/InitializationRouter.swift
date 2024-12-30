//
//  InitializationRouter.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import FeatureHome
import SharedDesignSystem

class InitializationRouter: InitializationRoutable, InitializationRouting {
    
    private let mainMandaratPageBuilder: MainMandaratBuilder
    
    private let navigationController: UINavigationController
    private let opacityTransitionDelegate: OpacityTransitionDelegate = .init()
    
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
    
    func presentMainMandaratPage(style: TransitionStyle = .default) {
        
        let router = mainMandaratPageBuilder.build()
        
        let viewController = router.viewController
        
        switch style {
        case .default:
            navigationController.pushViewController(viewController, animated: true)
        case .opacity:
            navigationController.delegate = opacityTransitionDelegate
            navigationController.pushViewController(viewController, animated: true)
            navigationController.delegate = nil
        }
        
        attach(router)
    }
    
    
    func presentNickNameInputPage() {
        
        let viewModel = NickNameInputPageViewModel()
        
        if let listener = interactor as? NickNameInputPageViewModelListener {
            
            viewModel.listener = listener
        }
        
        let viewController = NickNameInputPageViewController(reactor: viewModel)
        
        navigationController.pushViewController(viewController, animated: false)
    }
}
