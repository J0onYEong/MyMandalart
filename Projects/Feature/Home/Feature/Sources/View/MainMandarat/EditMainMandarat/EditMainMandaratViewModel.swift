//
//  EditMainMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import DomainMandaratInterface

import ReactorKit
import RxSwift

class EditMainMandaratViewModel: Reactor {
    
    let initialState: State
    
    init() {
        
        // Set initial state
        self.initialState = .init(
            titleText: "",
            descriptionText: ""
        )
    }
    
    public func editWithPreviousData(_ mainMandaratVO: MainMandaratVO?) {
        action.onNext(.editRequestFromOutside(mainMandarat: mainMandaratVO))
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .editTitleText(let text):
            
            var newState = state
            newState.titleText = text
            
            return newState
            
        case .editDescriptionText(let text):
            
            var newState = state
            newState.titleText = text
            
            return newState
            
        default:
            return state
        }
    }
}

extension EditMainMandaratViewModel {
    
    enum Action {
        
        // Event
        case editRequestFromOutside(mainMandarat: MainMandaratVO?)
        
        case editTitleText(text: String)
        case editDescriptionText(text: String)
        
        // Side effect
    }
    
    struct State {
        
        var titleText: String
        var descriptionText: String
    }
}
