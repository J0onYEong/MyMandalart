//
//  MainMandaratComponent.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import UIKit

import FeatureSubMandarat
import FeatureSetting

import SharedPresentationExt
import DomainMandaratInterface
import DomainUserStateInterface

class MainMandaratComponent: Componentable<MainMandaratDependency>, SubMandaratPageDependency, SettingPageDependency {

    
    var mandaratUseCase: MandaratUseCase {
        dependency.mandaratUseCase
    }
    
    var userStateUseCase: UserStateUseCase {
        dependency.userStateUseCase
    }
    
    var navigationController: NavigationControllable {
        dependency.navigationController
    }
}
