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
    
    public func build(mainMandaratVO: MainMandaratVO) -> any SubMandaratPageRoutable {
        
        let component = SubMandaratPageComponent(dependency: dependency)
        
        let viewModel = SubMandaratPageViewModel(
            mandaratUseCase: component.mandaratUseCase,
            mainMandarat: mainMandaratVO
        )
        
        let viewController = SubMandaratPageViewController()
        viewController.bind(reactor: viewModel)
        
        let router = SubMandaratPageRouter(
            navigationController: component.navigationController,
            viewModel: viewModel,
            viewController: viewController
        )
        
        return router
    }
}
