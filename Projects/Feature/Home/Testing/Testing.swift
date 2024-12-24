//
//  Testing.swift
//
//

import Foundation

import DomainMandaratInterface

import RxSwift

class MockMandaratUseCase: MandaratUseCase {
    
    func requestMainMandarats() -> RxSwift.Single<[DomainMandaratInterface.MainMandaratVO]> {
        
        return .just([])
    }
    
    func requestSubMandarats(mainMandarat: DomainMandaratInterface.MainMandaratVO) -> RxSwift.Single<[DomainMandaratInterface.SubMandaratVO]> {
        
        return .just([])
    }
    
    func saveMainMandarat(mainMandarat: DomainMandaratInterface.MainMandaratVO) {
        
    }
    
    func saveSubMandarat(mainMandarat: DomainMandaratInterface.MainMandaratVO) {
        
    }
}
