//
//  SubMandaratPageDependency.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import UIKit

import SharedPresentationExt
import SharedLoggerInterface

import DomainMandaratInterface
import DomainUserStateInterface

public protocol SubMandaratPageDependency {
    
    var mandaratUseCase: MandaratUseCase { get }
    var userStateUseCase: UserStateUseCase { get }
    
    var navigationController: NavigationControllable { get }
    
    var logger: Logger { get }
}
