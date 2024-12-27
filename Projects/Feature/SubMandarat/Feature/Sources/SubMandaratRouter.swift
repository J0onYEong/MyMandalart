//
//  SubMandaratPageRouter.swift
//  Home
//
//  Created by choijunios on 12/27/24.
//

import UIKit

import DomainMandaratInterface

protocol SubMandaratPageRouting: AnyObject {
    
    func presentEditSubMandaratPage(subMandaratVO: SubMandaratVO)
    
    func dismissEditSubMandaratPage()
}


class SubMandaratPageRouter: SubMandaratPageRoutable, SubMandaratPageRouting {
    
    // Public interface
    let viewModel: SubMandaratPageViewModelable
    let viewController: SubMandaratPageViewControllable
    let transitionDelegate: UINavigationControllerDelegate = SubMandaratViewControllerTransitionDelegate()
    
    
    // Navigation
    private let navigationController: UINavigationController
    
    
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
    
    
    func dismissEditSubMandaratPage() {
        
        if navigationController.presentedViewController is EditSubMandaratViewController {
            
            navigationController.dismiss(animated: true)
        }
    }
}

