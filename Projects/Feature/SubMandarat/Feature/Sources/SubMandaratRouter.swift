//
//  SubMandaratPageRouter.swift
//  Home
//
//  Created by choijunios on 12/27/24.
//

import UIKit

import FeatureSubMandaratInterface
import DomainMandaratInterface

protocol SubMandaratPageRouting: AnyObject {
    
    func presentEditSubMandaratPage(subMandaratVO: SubMandaratVO)
    
    func dismiss()
    
    func dismissSubMandaratPage()
}


class SubMandaratPageRouter: SubMandaratPageRoutable, SubMandaratPageRouting {
    
    let viewModel: SubMandaratPageViewModelable
    let viewController: SubMandaratPageViewControllable

    
    // Navigation
    private let navigationController: UINavigationController
    private let transitionDelegate: SubMandaratViewControllerTransitionDelegate = .init()
    
    
    init(navigationController: UINavigationController, viewModel: SubMandaratPageViewModel, viewController: SubMandaratPageViewController) {
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.viewController = viewController
        
        viewModel.router = self
    }
}


// MARK: SubMandaratPageRouting
extension SubMandaratPageRouter {
    
    func presentEditSubMandaratPage(subMandaratVO: SubMandaratVO) {
        
        let viewModel: EditSubMandartViewModel = .init(subMandaratVO)
        viewModel.router = self
        
        if let listener = self.viewModel as? EditSubMandaratViewModelListener {
            
            viewModel.listener = listener
        }
        
        let viewController: EditSubMandaratViewController = .init()
        viewController.bind(reactor: viewModel)
                
        viewController.modalPresentationStyle = .custom
        navigationController.present(
            viewController,
            animated: true
        )
    }
    
    
    func dismissSubMandaratPage() {
        
        navigationController.delegate = transitionDelegate
        navigationController.popViewController(animated: true)
        navigationController.delegate = nil
    }
    
    
    func dismiss() {
        
        if navigationController.presentedViewController != nil {
            
            navigationController.dismiss(animated: true)
        }
    }
}

