//
//  SubMandaratPageDependency.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import UIKit

import DomainMandaratInterface
import DataUserStateInterface

public protocol SubMandaratPageDependency {
    
    var mandaratUseCase: MandaratUseCase { get }
    var userStateRepository: UserStateRepository { get }
    var navigationController: UINavigationController { get }
}
