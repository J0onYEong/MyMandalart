//
//  MainMandaratDependency.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import UIKit

import SharedPresentationExt
import SharedLoggerInterface

import DomainMandaratInterface
import DomainUserStateInterface

public protocol MainMandaratDependency {
    
    var mandaratUseCase: MandaratUseCase { get }
    var userStateUseCase: UserStateUseCase { get }
    
    var navigationController: NavigationControllable { get }
    
    var logger: Logger { get }
}
