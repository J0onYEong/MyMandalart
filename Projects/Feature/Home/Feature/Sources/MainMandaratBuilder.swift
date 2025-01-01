//
//  MainMandaratBuilder.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import FeatureSubMandarat
import FeatureSetting

import SharedPresentationExt

public class MainMandaratBuilder: Buildable<MainMandaratDependency>, MainMandaratBuildable {
    
    public func build() -> MainMandaratRoutable {
    
        let component = MainMandaratComponent(dependency: dependency)
        
        
        let viewModel = MainMandaratPageViewModel(
            mandaratUseCase: component.dependency.mandaratUseCase,
            userStateUseCase: component.dependency.userStateUseCase,
            logger: component.dependency.logger
        )
        
        
        let viewController = MainMandaratPageViewController(
            reactor: viewModel
        )
        
        
        // SubMandaratPageBuilder
        let subMandaratBuilder = SubMandaratPageBuilder(dependency: component)
        
        
        // SettingPageBuilder
        let settingPageBuilder = SettingPageBuilder(dependency: component)
        
        
        let router = MainMandaratRouter(
            subMandaratBuilder: subMandaratBuilder,
            settingPageBuilder: settingPageBuilder,
            navigationController: component.dependency.navigationController,
            viewModel: viewModel,
            viewController: viewController
        )
        
        return router
    }
}

