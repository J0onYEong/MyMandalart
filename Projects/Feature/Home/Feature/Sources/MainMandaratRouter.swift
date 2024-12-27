//
//  MainMandaratCoordinator.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import UIKit

import FeatureSubMandarat
import DomainMandaratInterface
import SharedPresentationExt

protocol MainMandaratPageRouting: AnyObject {
    
    func presentEditMainMandaratPage(mainMandarat: MainMandaratVO)
    
    func dismissEditMainMandaratPage()

    func presentSubMandaratPage(mainMandarat: MainMandaratVO)
    
    func dismissSubMandaratPage()
}

class MainMandaratRouter: MainMandaratRoutable, MainMandaratPageRouting {
    
    let viewModel: MainMandaratPageViewModelable
    let viewController: MainMandaratPageViewControllable
    
    
    private let navigationController: UINavigationController
    private let subMandaratBuilder: SubMandaratPageBuildable
    
    
    init(
        subMandaratBuilder: SubMandaratPageBuildable,
        navigationController: UINavigationController,
        viewModel: MainMandaratPageViewModel,
        viewController: MainMandaratPageViewController)
    {
        self.subMandaratBuilder = subMandaratBuilder
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.viewController = viewController
        
        viewModel.router = self
    }
}


// MARK: MainMandaratPageRouting
extension MainMandaratRouter {
    
    func presentSubMandaratPage(mainMandarat: MainMandaratVO) {
        
        let router = subMandaratBuilder.build(mainMandaratVO: mainMandarat)
        
        let viewController = router.viewController
        
        navigationController.delegate = router.transitionDelegate
        navigationController.pushViewController(viewController, animated: true)
        navigationController.delegate = nil
    }
    
    
    func dismissSubMandaratPage() {
        
        
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
    
    
    func dismissEditMainMandaratPage() {
        
        if navigationController.presentedViewController is EditMainMandaratViewController {
            
            navigationController.dismiss(animated: true)
        }
    }
}
