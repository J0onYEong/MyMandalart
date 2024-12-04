//
//  HomeViewModel.swift
//  Home
//
//  Created by choijunios on 12/4/24.
//

import ReactorKit

class HomeViewModel: Reactor {
    
    private(set) var initialState: State = .init()
    
    init() { }
    
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
    }
    
    struct State {
        
        
    }
}
