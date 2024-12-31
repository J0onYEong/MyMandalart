//
//  SettingPageBuilder.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import SharedPresentationExt

public class SettingPageBuilder: Buildable<SettingPageDependency>, SettingPageBuildable {
    
    public func build(interactorListener: SettingPageViewModelListener) -> SettingPageRoutable {
        
        let component = SettingPageComponent(dependency: dependency)
        
        let viewModel = SettingPageViewModel(
            listener: interactorListener,
            userStateUseCase: component.dependency.userStateUseCase
        )
        
        let viewController = SettingPageViewController(reactor: viewModel)
        
        let router = SettingPageRouter(
            navigationController: component.dependency.navigationController,
            viewModel: viewModel,
            viewController: viewController
        )
        
        return router
    }
}
