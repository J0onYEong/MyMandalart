//
//  MainMandaratComponent.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import UIKit

import FeatureSubMandarat
import SharedPresentationExt
import DomainMandaratInterface
import DomainUserStateInterface

class MainMandaratComponent: Componentable<MainMandaratDependency>, SubMandaratPageDependency {
    
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
