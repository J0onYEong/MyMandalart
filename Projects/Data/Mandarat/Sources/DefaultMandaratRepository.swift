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
    
    // MARK: Fetching
    
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
                            hexColor: coreDataEntity.hexColor ?? "#000000",
                            description: coreDataEntity.story,
                            imageURL: coreDataEntity.imageURL
                        )
                        
                    }
                
            }
    }
    
    public func requestSubMandarat(root: any Identifiable) -> RxSwift.Single<[DomainMandaratInterface.SubMandaratVO]> {
        
        return .just([])
    }
    
    
    // MARK: Saving
    public func requestSaveMainMandarat(mainMandarat: MainMandaratVO) -> Single<Void> {
        
        let position = mainMandarat.position
        let predicate: NSPredicate = .init(
            format: "position.xpos == %d AND position.ypos == %d",
            position.matrixCoordinate.0,
            position.matrixCoordinate.1
        )
        
        let fetchedMandarat: Observable<[MainMandaratEntity]> = coreDataService
            .fetch(predicate: predicate)
            .asObservable()
            .share()
        
        
        return fetchedMandarat
            .withUnretained(self)
            .flatMap { repository, entities in
                
                if entities.isEmpty {
                    
                    // 새로운 엔티티 만들기
                    debugPrint("DefaultMandaratRepository: 새로운 메인 만다라트 엔티티 생성")
                    
                    return repository.saveMandarat(mainMandarat: mainMandarat)
                    
                } else {
                    
                    // 기존 엔티티 업데이트
                    debugPrint("DefaultMandaratRepository: 기존 만다라트 엔티티 업데이트")
                    
                    return repository.coreDataService.save { context, completion in
                        
                        let firstEntity = entities.first!
                        
                        let mandaratPos = mainMandarat.position.matrixCoordinate
                        firstEntity.position?.xpos = mandaratPos.0
                        firstEntity.position?.ypos = mandaratPos.1
                        
                        firstEntity.id = mainMandarat.id
                        firstEntity.title = mainMandarat.title
                        firstEntity.hexColor = mainMandarat.hexColor
                        firstEntity.story = mainMandarat.description
                        firstEntity.imageURL = mainMandarat.imageURL
                        
                        do {
                            try context.save()
                            completion(.success(()))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
                
            }
            .asSingle()
    }
    
    private func saveMandarat(mainMandarat: MainMandaratVO) -> Single<Void> {
        
        coreDataService.save { [mainMandarat] context, completion in
            
            let mainMandaratEntity = MainMandaratEntity(context: context)
            let positionEntity = MandaratPositionEntity(context: context)
            
            let mandaratPos = mainMandarat.position.matrixCoordinate
            positionEntity.xpos = mandaratPos.0
            positionEntity.ypos = mandaratPos.1
            
            mainMandaratEntity.id = mainMandarat.id
            mainMandaratEntity.title = mainMandarat.title
            mainMandaratEntity.position = positionEntity
            mainMandaratEntity.hexColor = mainMandarat.hexColor
            mainMandaratEntity.story = mainMandarat.description
            mainMandaratEntity.imageURL = mainMandarat.imageURL
            
            do {
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
