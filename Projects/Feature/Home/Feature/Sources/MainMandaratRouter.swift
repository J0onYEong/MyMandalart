//
//  MainMandaratCoordinator.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import UIKit

import FeatureHomeInterface
import DomainMandaratInterface
import SharedPresentationExt

protocol MainMandaratPageRouting: AnyObject {
    
    func presentEditMainMandaratPage(mainMandarat: MainMandaratVO)

    func presentSubMandaratPage(mainMandarat: MainMandaratVO)
}

class MainMandaratRouter: MainMandaratRoutable, MainMandaratPageRouting {
    
    let viewModel: MainMandaratPageViewModelable
    let viewController: MainMandaratPageViewControllable
    
    
    private let navigationController: UINavigationController
    
    
    init(
        navigationController: UINavigationController,
        viewModel: MainMandaratPageViewModel,
        viewController: MainMandaratPageViewController)
    {
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.viewController = viewController
        
        viewModel.router = self
    }
}


// MARK: MainMandaratPageRouting
extension MainMandaratRouter {
    
    func presentSubMandaratPage(mainMandarat: MainMandaratVO) {
        
    }
    
    func presentEditMainMandaratPage(mainMandarat: MainMandaratVO) {
        
    }
}
