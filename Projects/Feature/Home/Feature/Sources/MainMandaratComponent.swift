//
//  MainMandaratComponent.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import UIKit

import FeatureHomeInterface
import SharedPresentationExt
import DomainMandaratInterface

class MainMandaratComponent: Componentable<MainMandaratDependency> {
    
    var mandaratUseCase: MandaratUseCase {
        
        dependency.mandaratUseCase
    }
    
    var navigationController: UINavigationController {
        
        dependency.navigationController
    }
}
