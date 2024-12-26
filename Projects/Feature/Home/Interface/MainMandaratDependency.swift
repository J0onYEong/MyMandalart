//
//  MainMandaratDependency.swift
//  HomeInterface
//
//  Created by choijunios on 12/26/24.
//

import UIKit

import DomainMandaratInterface

public protocol MainMandaratDependency {
    
    var mandaratUseCase: MandaratUseCase { get }
    var navigationController: UINavigationController { get }
}
