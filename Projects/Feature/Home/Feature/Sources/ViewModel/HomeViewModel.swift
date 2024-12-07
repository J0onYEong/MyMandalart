//
//  HomeViewModel.swift
//  Home
//
//  Created by choijunios on 12/4/24.
//

import ReactorKit

import DomainMandaratInterface

class HomeViewModel: Reactor {
    
    // 의존성 주입
    private let mandaratUseCase: MandaratUseCase
    
    private(set) var initialState: State = .init()
    
    init(mandaratUseCase: MandaratUseCase) {
        
        self.mandaratUseCase = mandaratUseCase
    }
    
    func mutate(action: Action) -> Observable<Action> {
        
        switch action {
        case .viewDidLoad:
            return mandaratUseCase
                .requestMainMandarats()
                .asObservable()
                .map { mainMandarats in
                    
                    Action.fetchedMainMandarat(mainMandarats)
                }
            
        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
            
            
        default:
            return state
        }
        
    }
}

extension HomeViewModel {
    
    enum Action {
        
        // Event
        case viewDidLoad
        
        // Side effect
        case fetchedMainMandarat([MainMandaratVO])
    }
    
    struct State {
        
        
    }
}
