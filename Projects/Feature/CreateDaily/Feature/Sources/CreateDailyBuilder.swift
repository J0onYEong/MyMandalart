//
//  CreateDailyBuilder.swift
//  CreateDaily
//
//  Created by choijunios on 2/28/25.
//

import SharedPresentationExt

public class CreateDailyBuilder: Buildable<CreateDailyDependency>, CreateDailyBuildable {
    
    public override init(dependency: CreateDailyDependency) {
        super.init(dependency: dependency)
    }
    
    public func build() -> CreateDailyRoutable {
        let component = CreateDailyComponent(dependency: dependency)
        let viewModel = CreateDailyViewModel()
        let viewController = CreateDailyViewController(reactor: viewModel)
        let router = CreateDailyRouter(viewModel: viewModel, viewController: viewController)
        return router
    }
}
