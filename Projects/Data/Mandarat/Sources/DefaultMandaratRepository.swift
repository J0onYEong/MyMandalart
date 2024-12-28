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
    
    
    public func requestSubMandarat(identifier: String) -> Single<[SubMandaratVO]> {
        
        let predicate: NSPredicate = .init(format: "id == %@", identifier)
        
        let fetchedMandarat: Observable<[MainMandaratEntity]> = coreDataService
            .fetch(predicate: predicate)
            .asObservable()
        
        return fetchedMandarat
            .map { mainMandarats in
                
                if mainMandarats.isEmpty {
                    
                    debugPrint("메인 만다라트를 찾을 수 없음")
                    return []
                    
                }
                
                let subMandaratEntities = mainMandarats.first!.subMandarats as! Set<SubMandaratEntity>
                
                return subMandaratEntities.map { coreDataEntity in
                    
                    let mandaratPos: MandaratPositionEntity! = coreDataEntity.position
                    
                    return SubMandaratVO(
                        id: coreDataEntity.id!,
                        title: coreDataEntity.title!,
                        acheivementRate: Double(coreDataEntity.achievementRate),
                        position: .init(x: mandaratPos.xpos, y: mandaratPos.ypos)!
                    )
                }
            }
            .asSingle()
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
    
    
    public func requestSaveSubMandarat(identifier mainMandaratId: String, subMandarat: SubMandaratVO) -> Single<Void> {
        
        // 서브만다라트 존재여부 확인
        let subMandaratId = subMandarat.id
        let predicate: NSPredicate = .init(format: "id == %@", subMandaratId)
        
        let fetchedSubMandarats: Observable<[SubMandaratEntity]> = coreDataService
            .fetch(predicate: predicate)
            .asObservable()
        
        let resultSwitch = fetchedSubMandarats
            .map { $0.first }
            .share()
        
        let updatePreviousDataStream = resultSwitch.compactMap({ $0 })
        let createNewDataStream = resultSwitch.filter({ $0 == nil })
        
        
        // updatePreviousDataStream
        let updatePreviousResult = updatePreviousDataStream
            .flatMap { [coreDataService, subMandarat] entity in
                
                debugPrint("기존에 존재하던 서브 만다라트 업데이트")
                
                return coreDataService.save { context, completion in
                    
                    entity.title = subMandarat.title
                    entity.achievementRate = Float(subMandarat.acheivementRate)
                    
                    do {
                        try context.save()
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            
        
        // createNewDataStream
        let createNewDataResult = createNewDataStream
            .flatMap { [coreDataService, mainMandaratId, subMandarat] _ in
                
                debugPrint("새로운 서브 만다라트 생성")
                
                return coreDataService.save { context, completion in
                    
                    let predicate: NSPredicate = .init(format: "id == %@", mainMandaratId)
                    
                    let fetchRequest = MainMandaratEntity.fetchRequest()
                    
                    do {
                        
                        let mainMandarats = try context.fetch(fetchRequest)
                        if mainMandarats.isEmpty {
                            fatalError("서브만다라트 저장 실패, 일치하는 메인만다라트 엔티티를 찾을 수 없음")
                        }
                        let mainMandarat = mainMandarats.first!
                        
                        let subMandaratEntity = SubMandaratEntity(context: context)
                        let positionEntity = MandaratPositionEntity(context: context)
                        
                        let mandaratPos = subMandarat.position.matrixCoordinate
                        positionEntity.xpos = mandaratPos.0
                        positionEntity.ypos = mandaratPos.1
                        
                        subMandaratEntity.id = subMandarat.id
                        subMandaratEntity.position = positionEntity
                        subMandaratEntity.title = subMandarat.title
                        subMandaratEntity.achievementRate = Float(subMandarat.acheivementRate)
                        
                        if let prevSet = mainMandarat.subMandarats {
                                
                            mainMandarat.subMandarats = prevSet.adding(subMandaratEntity) as NSSet
                        } else {
                            
                            mainMandarat.subMandarats = NSSet(object: subMandaratEntity)
                        }
                        
                        try context.save()
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        

        return Observable
            .merge(updatePreviousResult, createNewDataResult)
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
