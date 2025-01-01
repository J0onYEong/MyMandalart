//
//  InitializationDependency.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import SharedPresentationExt
import SharedLoggerInterface

import DomainUserStateInterface
import DomainMandaratInterface

public protocol InitializationDependency {
    
    var userStateUseCase: UserStateUseCase { get }
    var mandaratUseCase: MandaratUseCase { get }
    
    var navigationController: NavigationControllable { get }
    
    var logger: Logger { get }
}
