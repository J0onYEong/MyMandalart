//
//  MainMandaratBuilder.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import FeatureHomeInterface
import SharedPresentationExt

public class MainMandaratBuilder: Buildable<MainMandaratDependency>, MainMandaratBuildable {
    
    public func build() -> MainMandaratRoutable {
    
        let component = MainMandaratComponent(dependency: dependency)
        
        let viewModel = MainMandaratPageViewModel(
            mandaratUseCase: component.mandaratUseCase
        )
        
        let viewController = MainMandaratPageViewController(
            reactor: viewModel
        )
        
        let router = MainMandaratRouter(
            navigationController: component.navigationController,
            viewModel: viewModel,
            viewController: viewController
        )
        
        return router
    }
}

