//
//  InitializationComponent.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import FeatureHome

import SharedPresentationExt

import DomainMandaratInterface
import DomainUserStateInterface

import SharedPresentationExt
import SharedLoggerInterface

class InitializationComponent: Componentable<InitializationDependency>, MainMandaratDependency {
    
    var navigationController: NavigationControllable {
        dependency.navigationController
    }
    
    var mandaratUseCase: MandaratUseCase {
        dependency.mandaratUseCase
    }
    
    var userStateUseCase: UserStateUseCase {
        dependency.userStateUseCase
    }
    
    var logger: Logger {
        dependency.logger
    }
}

