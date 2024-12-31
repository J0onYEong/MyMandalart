//
//  SettingPageRouter.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import SharedPresentationExt



class SettingPageRouter: SettingPageRoutable, SettingPageRouting {
    
    
    init(viewModel: SettingPageViewModel, viewController: SettingPageViewController) {
        
        super.init(viewModel: viewModel, viewController: viewController)
        
        viewModel.router = self
    }
    
}
