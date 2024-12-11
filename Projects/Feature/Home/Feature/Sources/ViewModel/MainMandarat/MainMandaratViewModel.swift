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
    private let position: MandaratPosition
    
    public weak var delegate: MainMandaratViewModelDelegate?
    
    init(position: MandaratPosition) {
        
        self.position = position
        
        self.initialState = .init()
    }
    
    public func requestRender(_ mandaratRO: MainMandaratRO) {
        
        action.onNext(.mandaratDataFromOutside(mandaratRO))
    }
    
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .addMandaratButtonClicked:
            
            delegate?.mainMandarat(buttonClicked: position)
            
            return state
            
        case .mandaratDataFromOutside(let mainMandaratRO):
            
            var newState = state
            newState.mandarat = mainMandaratRO
            
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
        case mandaratDataFromOutside(MainMandaratRO)
        
        // Side effect
        
    }
    
    struct State {
        
        var mandarat: MainMandaratRO?
        
        public var isAvailable: Bool { mandarat != nil }
        
    }
}
