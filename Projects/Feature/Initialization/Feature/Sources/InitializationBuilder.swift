//
//  InitializationBuilder.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import FeatureHome

import SharedPresentationExt

public class InitializationBuilder: Buildable<InitializationDependency>, InitializationBuildable {
    
    public func build() -> InitializationRoutable {
        
        let component = InitializationComponent(dependency: dependency)
        
        
        let interactor = InitializationInteractor(
            userStateUseCase: component.dependency.userStateUseCase
        )
        
        
        let mainMandaratBuilder = MainMandaratBuilder(dependency: component)
        
        
        let router = InitializationRouter(
            mainMandaratPageBuilder: mainMandaratBuilder,
            navigationController: component.dependency.navigationController,
            interactor: interactor
        )
        
        return router
    }
}
