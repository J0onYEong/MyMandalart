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
    
    private let disposeBag: DisposeBag = .init()
    
    public init(mandaratRepository: MandaratRepository) {
        
        self.mandaratRepository = mandaratRepository
    }
    
    
    // MARK: Main mandarat
    public func requestMainMandarats() -> RxSwift.Single<[DomainMandaratInterface.MainMandaratVO]> {
        
        mandaratRepository.requestMainMandarat()
    }
    
    public func saveMainMandarat(mainMandarat: MainMandaratVO) {
        
        mandaratRepository
            .requestSaveMainMandarat(mainMandarat: mainMandarat)
            .subscribe(onFailure: { error in
                
                // 부가적인 에러처리
                
                print(error.localizedDescription)
                
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: Sub mandarat
    public func requestSubMandarats(mainMandarat: DomainMandaratInterface.MainMandaratVO) -> RxSwift.Single<[DomainMandaratInterface.SubMandaratVO]> {
        
        mandaratRepository.requestSubMandarat(root: mainMandarat)
    }
    
    public func saveSubMandarat(mainMandarat: MainMandaratVO) {
        
        // 서브 만다라트 저장로직
        
    }
}
