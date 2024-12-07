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
            
        let entityPublisher: Single<[MainMandaratEntity]> = coreDataService.fetch(predicate: nil)
        
        return entityPublisher
            .map { coreDataEntities in
                
                // MARK: CoreDataEntity -> DomainEntity
                
                coreDataEntities
                    .map { coreDataEntity in
                        
                        let mandaratPos: MandaratPositionEntity! = coreDataEntity.position
                        
                        return MainMandaratVO(
                            id: coreDataEntity.id!,
                            title: coreDataEntity.title!,
                            position: .init(x: mandaratPos.xpos, y: mandaratPos.ypos)!,
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
