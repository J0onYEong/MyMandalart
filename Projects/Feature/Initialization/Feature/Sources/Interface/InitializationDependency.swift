//
//  InitializationDependency.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import DomainUserStateInterface
import DomainMandaratInterface


public protocol InitializationDependency {
    
    var userStateUseCase: UserStateUseCase { get }
    var mandaratUseCase: MandaratUseCase { get }
    var navigationController: UINavigationController { get }
}
