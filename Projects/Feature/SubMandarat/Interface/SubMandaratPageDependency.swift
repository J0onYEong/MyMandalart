//
//  SubMandaratPageDependency.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import UIKit

import DomainMandaratInterface

public protocol SubMandaratPageDependency {
    
    var mandaratUseCase: MandaratUseCase { get }
    var navigationController: UINavigationController { get }
    var mainMandaratVO: MainMandaratVO { get }
}
