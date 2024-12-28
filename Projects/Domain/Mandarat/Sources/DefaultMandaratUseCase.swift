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
                
                debugPrint("메인만다라트 저장실패 \(error.localizedDescription)")
                
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: Sub mandarat
    public func requestSubMandarats(mainMandarat: DomainMandaratInterface.MainMandaratVO) -> RxSwift.Single<[DomainMandaratInterface.SubMandaratVO]> {
        
        let identifier = mainMandarat.id
        
        return mandaratRepository.requestSubMandarat(identifier: identifier)
    }
    
    public func saveSubMandarat(mainMandarat: MainMandaratVO, subMandarat: SubMandaratVO) {
        
        let identifier = mainMandarat.id
        
        mandaratRepository
            .requestSaveSubMandarat(
                identifier: identifier,
                subMandarat: subMandarat
            )
            .subscribe(onFailure: { error in
                
                debugPrint("서브 만다라트 저장 실패 \(error.localizedDescription)")
                
            })
            .disposed(by: disposeBag)
    }
}
