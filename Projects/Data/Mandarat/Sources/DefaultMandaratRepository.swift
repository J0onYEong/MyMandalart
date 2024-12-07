//
//  DefaultMandaratRepository.swift
//  Mandarat
//
//  Created by choijunios on 12/7/24.
//

import Foundation

import DomainMandaratInterface
import DataCoreDataInterface

import RxSwift


public class DefaultMandaratRepository: MandaratRepository {
    
    private let coreDataService: CoreDataService
    
    public init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    public func requestMainMandarat() -> RxSwift.Single<[DomainMandaratInterface.MainMandaratVO]> {
            
        let entityPublisher: Single<[MainMandarat]> = coreDataService.fetch(predicate: nil)
        
        return entityPublisher
            .map { coreDataEntities in
                
                // MARK: CoreDataEntity -> DomainEntity
                
                coreDataEntities
                    .map { coreDataEntity in
                        
                        MainMandaratVO(
                            id: coreDataEntity.id ?? "",
                            title: coreDataEntity.title ?? "",
                            position: .ONE_ONE,
                            hexColor: coreDataEntity.hexColor,
                            description: coreDataEntity.story,
                            imageURL: coreDataEntity.imageURL
                        )
                        
                    }
                
            }
    }
    
    public func requestSubMandarat(root: any Identifiable) -> RxSwift.Single<[DomainMandaratInterface.SubMandaratVO]> {
        
        return .just([])
    }
}
