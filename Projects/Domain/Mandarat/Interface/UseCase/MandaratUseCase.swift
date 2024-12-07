//
//  MandaratUseCase.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

import RxSwift

public protocol MandaratUseCase {
    
    /// 메인 만다라트를 요청합니다.
    func requestMainMandarats() -> Single<[MainMandaratVO]>
    
    
    /// 메인 만다라트의 서브 만다라트를 요청합니다.
    func requestSubMandarats(mainMandarat: MainMandaratVO) -> Single<[SubMandaratVO]>
    
    
    /// 메인 만다라트를 저장할 것을 요청합니다.
    func saveMainMandarat(mainMandarat: MainMandaratVO)
}
