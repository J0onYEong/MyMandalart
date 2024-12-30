//
//  InitializationDependency.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import DomainMandaratInterface
import DataUserStateInterface

public protocol InitializationDependency {
    
    var userStateRepository: UserStateRepository { get }
    var navigationController: UINavigationController { get }
}
