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
    
    func dismiss()
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
        
        // 메인 만다라트 화면과 결합력이 강해 빌더를 따로 만들지 않았습니다.
        
        let viewModel: EditMainMandaratViewModel = .init(mainMandarat)
        viewModel.router = self
        
        if let delegate = self.viewModel as? EditMainMandaratViewModelDelegate {
            
            viewModel.delegate = delegate
        }
        
        let viewController = EditMainMandaratViewController()
        viewController.bind(reactor: viewModel)
        
        
        viewController.modalPresentationStyle = .custom
        navigationController.present(
            viewController,
            animated: true
        )
    }
    
    
    func dismiss() {
        
        if navigationController.presentedViewController != nil {
            
            navigationController.dismiss(animated: true)
        }
    }
}
