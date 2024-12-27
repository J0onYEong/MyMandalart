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
    
    public func build() -> any SubMandaratPageRoutable {
        
        let component = SubMandaratPageComponent(dependency: dependency)
        
        let viewModel = SubMandaratPageViewModel(
            mandaratUseCase: component.mandaratUseCase,
            mainMandarat: component.mandaratVO
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




// MARK: Interface
public protocol SubMandaratPageViewModelable { }

public protocol SubMandaratPageViewControllable: UIViewController { }



public protocol SubMandaratPageDependency {
    
    var mandaratUseCase: MandaratUseCase { get }
    var navigationController: UINavigationController { get }
    var mainMandaratVO: MainMandaratVO { get }
}


public protocol SubMandaratPageBuildable: Buildable<SubMandaratPageDependency> {
    
    func build() -> SubMandaratPageRoutable
}

public protocol SubMandaratPageRoutable {
    var viewModel: SubMandaratPageViewModelable { get }
    var viewController: SubMandaratPageViewControllable { get }
}
