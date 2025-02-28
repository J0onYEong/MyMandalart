//
//  CreateDailyViewModel.swift
//  CreateDaily
//
//  Created by choijunios on 2/28/25.
//

import ReactorKit

class CreateDailyViewModel: Reactor, CreateDailyViewModelable {
    
    var initialState: State
    
    init() {
        self.initialState = .init()
    }
    
    
    func mutate(action: Action) -> Observable<Action> {
        return .just(action)
    }
    
    
    func reduce(state: State, mutation: Action) -> State {
        var newState = state
        return newState
    }
    
}


// MARK: Public interface
extension CreateDailyViewModel {
    enum Action {
        
    }
    struct State {
        
    }
    
}
