//
//  DefaultMandaratUseCase.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

import DomainMandaratInterface
import SharedCore

import RxSwift

public class DefaultMandaratUseCase: MandaratUseCase {
    
    // Service locator
    @Inject private var mandaratRepository: MandaratRepository
    
    public init() {
        
    }
    
    public func requestMainMandarats() -> RxSwift.Single<[DomainMandaratInterface.MainMandaratVO]> {
        
        mandaratRepository.requestMainMandarat()
    }
    
    public func requestSubMandarats(mainMandarat: DomainMandaratInterface.MainMandaratVO) -> RxSwift.Single<[DomainMandaratInterface.SubMandaratVO]> {
        
        mandaratRepository.requestSubMandarat(root: mainMandarat)
    }
    
}
