//
//  SettingPageDependency.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import UIKit

import DomainUserStateInterface

public protocol SettingPageDependency {
    
    var userStateUseCase: UserStateUseCase { get }
    var navigationController: UINavigationController { get }
}
