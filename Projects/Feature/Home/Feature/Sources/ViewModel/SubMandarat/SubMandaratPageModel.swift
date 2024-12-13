//
//  SubMandaratPageModel.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import DomainMandaratInterface

import ReactorKit
import RxSwift

class SubMandaratPageModel: Reactor {
    
    var initialState: State = .init()
    
    // Sub ViewModel
    let mainMandaratViewModel: MainMandaratViewModel = .init(position: .TWO_TWO)
    private(set) var subMandaratViewModels: [MandaratPosition: SubMandaratViewModel] = [:]
    
    private let disposeBag: DisposeBag = .init()
    
    init(mainMandarat: MainMandaratVO, subMandarats: [SubMandaratVO]) {
        
        
        // 서브 만다라트 뷰모델 생성
        createSubMandaratViewModels()
        
        // 메인 만다라트 랜더링
        mainMandaratViewModel.requestRender(.create(from: mainMandarat))
    }
}

// MARK: Action & State
extension SubMandaratPageModel {
    
    enum Action {
        
    }
    
    struct State {
        
    }
}

private extension SubMandaratPageModel {
    
    func createSubMandaratViewModels() {
        
        MandaratPosition.allCases.filter({ $0 != .TRD_TWO })
            .forEach { position in
                
                self.subMandaratViewModels[position] = .init()
            }
    }
}
