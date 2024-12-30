//
//  InitializationBuilder.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import SharedPresentationExt

public class InitializationBuilder: Buildable<InitializationDependency>, InitializationBuildable {
    
    public func build() -> InitializationRoutable {
        
        let component = InitializationComponent(dependency: dependency)
        
        let interactor = InitializationInteractor(
            userStateUseCase: component.dependency.userStateUseCase
        )
        
        let router = InitializationRouter(
            navigationController: component.dependency.navigationController,
            interactor: interactor
        )
        
        return router
    }
}
