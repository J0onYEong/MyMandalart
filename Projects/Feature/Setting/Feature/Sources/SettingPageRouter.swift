//
//  SettingPageRouter.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import UIKit

import SharedPresentationExt

class SettingPageRouter: SettingPageRoutable, SettingPageRouting {
    
    private let navigationController: NavigationControllable
    
    init(
        navigationController: NavigationControllable,
        viewModel: SettingPageViewModel,
        viewController: SettingPageViewController) {
        
        self.navigationController = navigationController
            
        super.init(viewModel: viewModel, viewController: viewController)
        
        viewModel.router = self
    }
    
}


// MARK: SettingPageRouting
extension SettingPageRouter {
    
    func presentEditNickNamePage() {
        
        let viewModel = EditNickNamePageViewModel()
        
        if let listener = self.viewModel as? EditNickNamePageViewModelListener {
            
            viewModel.listener = listener
        }
        
        let viewController = EditNickNamePageViewController(reactor: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
    func popEditNickNamePage() {
        
        if navigationController.topViewController is EditNickNamePageViewController {
            
            navigationController.popViewController(animated: true)
        }
    }
    
    
    func openWebPage(url: URL) {
        
        UIApplication.shared.open(url)
    }
}
