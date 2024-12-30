//
//  RootComponent.swift
//  MyMandarat-iOS
//
//  Created by choijunios on 12/27/24.
//

import UIKit

import FeatureHome

import DomainMandaratInterface
import DomainMandarat

import DomainUserStateInterface
import DomainUserState

import DataUserState

import DataMandarat
import DataCoreData
import DataCoreDataInterface


class RootComponent: MainMandaratDependency {
    
    
    
    // MARK: Presentation
    let navigationController: UINavigationController
    
    
    // MARK: Domain
    lazy var mandaratUseCase: MandaratUseCase = DefaultMandaratUseCase(
        mandaratRepository: mandaratRepository
    )
    lazy var userStateUseCase: UserStateUseCase = DefaultUserStateUseCase(
        userStateRepository: userStateRepository
    )
    
    
    // MARK: Data
    lazy var mandaratRepository: MandaratRepository = DefaultMandaratRepository(
        coreDataService: coreDataService
    )
    let userStateRepository: UserStateRepository = DefaultUserStateRepository()
    
    let coreDataService: CoreDataService = DefaultCoreDataService()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
