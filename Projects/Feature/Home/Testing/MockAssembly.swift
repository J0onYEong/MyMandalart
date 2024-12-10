//
//  Mock.swift
//  Home
//
//  Created by choijunios on 12/10/24.
//

import SharedNavigationInterface

import Swinject

class MockAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(Router.self) { _ in
            Router()
        }
        .inObjectScope(.container)
        
    }
}
