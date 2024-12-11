//
//  Mock.swift
//  Home
//
//  Created by choijunios on 12/10/24.
//

import SharedNavigationInterface
import SharedAlertHelperInterface

import Swinject

class MockAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(Router.self) { _ in
            Router()
        }
        .inObjectScope(.container)
        
        container.register(AlertHelper.self) { resolver in
            let router = resolver.resolve(Router.self)!
            return AlertHelper(router: router)
        }
        .inObjectScope(.container)
        
    }
}
