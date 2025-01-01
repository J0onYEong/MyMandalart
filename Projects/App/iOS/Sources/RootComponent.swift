//
//  RootComponent.swift
//  MyMandarat-iOS
//
//  Created by choijunios on 12/27/24.
//

import UIKit

import FeatureInitialization

import SharedPresentationExt
import SharedLoggerInterface
import SharedLogger	

import DomainMandaratInterface
import DomainMandarat

import DomainUserStateInterface
import DomainUserState

import DataUserState

import DataMandarat
import DataCoreData
import DataCoreDataInterface


class RootComponent: InitializationDependency {
    
    
    
    // MARK: Presentation
    let navigationController: NavigationControllable
    
    
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
    
    
    // MARK: Shared
    let logger: Logger = DefaultLogger()
    
    
    init(navigationController: NavigationControllable) {
        self.navigationController = navigationController
    }
}
