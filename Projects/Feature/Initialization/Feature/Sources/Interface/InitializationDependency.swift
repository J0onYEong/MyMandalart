//
//  InitializationDependency.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import DomainUserStateInterface


public protocol InitializationDependency {
    
    var userStateUseCase: UserStateUseCase { get }
    var navigationController: UINavigationController { get }
}
