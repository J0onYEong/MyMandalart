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
    
    
    init() {
        
        self.initialState = .init()
    }
    
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .mandaratDataFromOutside(let mainMandaratVO):
            
            var newState = state
            newState.mandarat = mainMandaratVO
            
            return newState
        default:
            return state
        }
    }
}

extension MainMandaratViewModel {
    
    enum Action {
        
        // Event
        case addMandaratButtonClicked
        case mandaratDataFromOutside(MainMandaratVO)
        
        // Side effect
        
    }
    
    struct State {
        
        var mandarat: MainMandaratVO?
        
        public var isAvailable: Bool { mandarat != nil }
        
    }
}
