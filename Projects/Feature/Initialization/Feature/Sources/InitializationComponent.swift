//
//  InitializationComponent.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import FeatureHome

import DomainMandaratInterface
import DomainUserStateInterface

import SharedPresentationExt

import UIKit

class InitializationComponent: Componentable<InitializationDependency>, MainMandaratDependency {
    
    var mandaratUseCase: MandaratUseCase {
        dependency.mandaratUseCase
    }
    
    var userStateUseCase: UserStateUseCase {
        dependency.userStateUseCase
    }
    
    var navigationController: UINavigationController {
        dependency.navigationController
    }
}

