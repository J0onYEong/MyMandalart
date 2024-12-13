//
//  SubMandaratPageModel.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import SharedNavigationInterface
import DomainMandaratInterface
import SharedDependencyInjector

import ReactorKit
import RxSwift

class SubMandaratPageModel: Reactor, MainMandaratViewModelDelegate {
    
    // DI
    @Inject private var router: Router
    
    
    // State for view model
    private let mainMandaratVO: MainMandaratVO
    
    
    // State for view
    var initialState: State = .init()
    
    
    // Sub ViewModel
    let mainMandaratViewModel: MainMandaratViewModel
    private(set) var subMandaratViewModels: [MandaratPosition: SubMandaratViewModel] = [:]
    
    
    // Navigation
    let transitionDelegate: SubMandaratViewControllerTransitionDelegate = .init()
    
    
    private let disposeBag: DisposeBag = .init()
    
    
    
    init(mainMandarat: MainMandaratVO, subMandarats: [SubMandaratVO]) {
        
        self.mainMandaratVO = mainMandarat
        
        
        // 메인 만다라트 뷰모델 생성
        mainMandaratViewModel = .init(position: .TWO_TWO)
        mainMandaratViewModel.delegate = self
        
        
        // 서브 만다라트 뷰모델 생성
        createSubMandaratViewModels()
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .viewDidLoad:
            
            mainMandaratViewModel.requestRender(.create(from: mainMandaratVO))
            
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        switch mutation {
        case .viewDidLoad:
            return state
        }
    }
}

// MARK: Action & State
extension SubMandaratPageModel {
    
    enum Action {
        case viewDidLoad
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

extension SubMandaratPageModel {
    
    func mainMandarat(detailButtonClicked position: MandaratPosition) {
        
        router.pop(
            animated: true,
            delegate: transitionDelegate
        )
    }
}
