//
//  SubMandaratPageBuilder.swift
//  Home
//
//  Created by choijunios on 12/27/24.
//

import UIKit

import SharedPresentationExt
import DomainMandaratInterface

public class SubMandaratPageBuilder: Buildable<SubMandaratPageDependency>, SubMandaratPageBuildable {
    
    public func build(mainMandaratVO: MainMandaratVO) -> SubMandaratPageRoutable {
        
        let component = SubMandaratPageComponent(dependency: dependency)
        
        let viewModel = SubMandaratPageViewModel(
            mandaratUseCase: component.dependency.mandaratUseCase,
            userStateRepository: component.dependency.userStateRepository,
            mainMandarat: mainMandaratVO
        )
        
        let viewController = SubMandaratPageViewController()
        viewController.bind(reactor: viewModel)
        
        let router = SubMandaratPageRouter(
            navigationController: component.dependency.navigationController,
            viewModel: viewModel,
            viewController: viewController
        )
        
        return router
    }
}
