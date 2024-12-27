//
//  SubMandaratPageComponent.swift
//  Home
//
//  Created by choijunios on 12/27/24.
//

import UIKit

import DomainMandaratInterface
import SharedPresentationExt

class SubMandaratPageComponent: Componentable<SubMandaratPageDependency> {
    
    var navigationController: UINavigationController {
        dependency.navigationController
    }
    
    var mandaratUseCase: MandaratUseCase {
        dependency.mandaratUseCase
    }
    
    var mandaratVO: MainMandaratVO {
        dependency.mainMandaratVO
    }
}
