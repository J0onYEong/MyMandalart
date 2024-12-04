//
//  MandaratUseCase.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

import RxSwift

public protocol MandaratUseCase {
    
    func requestMainMandarats() -> Single<[MainMandaratVO]>
}
