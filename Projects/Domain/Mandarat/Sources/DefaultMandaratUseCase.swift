//
//  DefaultMandaratUseCase.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

import DomainMandaratInterface

import RxSwift

public class DefaultMandaratUseCase: MandaratUseCase {
    
    private let mandaratRepository: MandaratRepository
    
    public init(mandaratRepository: MandaratRepository) {
        
        self.mandaratRepository = mandaratRepository
    }
    
    public func requestMainMandarats() -> RxSwift.Single<[DomainMandaratInterface.MainMandaratVO]> {
        
        mandaratRepository.requestMainMandarat()
    }
    
    public func requestSubMandarats(mainMandarat: DomainMandaratInterface.MainMandaratVO) -> RxSwift.Single<[DomainMandaratInterface.SubMandaratVO]> {
        
        mandaratRepository.requestSubMandarat(root: mainMandarat)
    }
    
}
