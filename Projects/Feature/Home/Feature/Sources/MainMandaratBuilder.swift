//
//  MainMandaratBuilder.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import FeatureSubMandarat
import SharedPresentationExt

public class MainMandaratBuilder: Buildable<MainMandaratDependency>, MainMandaratBuildable {
    
    public func build() -> MainMandaratRoutable {
    
        let component = MainMandaratComponent(dependency: dependency)
        
        
        let viewModel = MainMandaratPageViewModel(
            mandaratUseCase: component.mandaratUseCase,
            userStateUseCase: component.dependency.userStateUseCase
        )
        
        
        let viewController = MainMandaratPageViewController(
            reactor: viewModel
        )
        
        
        // SubMandaratPageBuilder
        let subMandaratBuilder = SubMandaratPageBuilder(dependency: component)
        
        
        let router = MainMandaratRouter(
            subMandaratBuilder: subMandaratBuilder,
            navigationController: component.navigationController,
            viewModel: viewModel,
            viewController: viewController
        )
        
        return router
    }
}

