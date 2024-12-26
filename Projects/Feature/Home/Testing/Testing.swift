//
//  Testing.swift
//
//

import Foundation

import DomainMandaratInterface

import RxSwift

public class MockMandaratUseCase: MandaratUseCase {
    
    private var memoryStore_MM: [MandaratPosition: MainMandaratVO] = [:]
    private var memoryStore_SM: [MandaratPosition: [MandaratPosition: SubMandaratVO]] = [:]
    
    public init() { }
    
    public func requestMainMandarats() -> RxSwift.Single<[DomainMandaratInterface.MainMandaratVO]> {
        
        return .just(memoryStore_MM.values.map({ $0 }))
    }
    
    public func requestSubMandarats(mainMandarat: DomainMandaratInterface.MainMandaratVO) -> RxSwift.Single<[DomainMandaratInterface.SubMandaratVO]> {
        
        if let subMandaratDic = memoryStore_SM[mainMandarat.position] {
            
            let arr = subMandaratDic.values.map({ $0 })
            
            return .just(arr)
        }
        
        return .just([])
    }
    
    public func saveMainMandarat(mainMandarat: DomainMandaratInterface.MainMandaratVO) {
        
        let position = mainMandarat.position
        
        memoryStore_MM[position] = mainMandarat
    }
    
    public func saveSubMandarat(mainMandarat: MainMandaratVO, subMandarat: SubMandaratVO) {
        
        let mainPosition = mainMandarat.position
        let subPosition = subMandarat.position
        
        if memoryStore_SM[mainPosition] == nil {
           
            memoryStore_SM[mainPosition] = [:]
        }
        
        memoryStore_SM[mainPosition]![subPosition] = subMandarat
    }
}
