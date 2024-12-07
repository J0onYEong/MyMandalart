//
//  MainMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/7/24.
//

import Foundation

import DomainMandaratInterface

import ReactorKit
import RxSwift

class MainMandaratViewModel: Reactor {
    
    let initialState: State
    
    
    init(mandarat: MainMandaratVO?) {
        
        self.initialState = .init(
            mandarat: mandarat
        )
    }
    
    
    func reduce(state: State, mutation: Action) -> State {
        
        return state
    }
}

extension MainMandaratViewModel {
    
    enum Action {
        
        // Event
        case addMandaratButtonClicked
        
    }
    
    struct State {
        
        var mandarat: MainMandaratVO?
        
        public var isAvailable: Bool { mandarat != nil }
        
    }
}
