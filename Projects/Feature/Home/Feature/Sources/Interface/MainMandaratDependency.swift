//
//  MainMandaratDependency.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import UIKit

import DomainMandaratInterface
import DataUserStateInterface

public protocol MainMandaratDependency {
    
    var mandaratUseCase: MandaratUseCase { get }
    var userStateRepository: UserStateRepository { get }
    var navigationController: UINavigationController { get }
}
