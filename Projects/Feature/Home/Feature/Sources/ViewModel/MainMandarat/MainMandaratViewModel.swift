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
    
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .addMandaratButtonClicked:
            
            delegate?.mainMandarat(buttonClicked: position)
            
            return state
            
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
