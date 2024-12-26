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
    
    public weak var listener: MainMandaratViewModelListener!
    
    init(position: MandaratPosition) {
        
        self.position = position
        
        self.initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .addMandaratButtonClicked:
            
            listener.mainMandarat(editButtonClicked: position)
            return .never()
            
        case .mainMandaratDisplayViewClicked:
            
            listener.mainMandarat(detailButtonClicked: position)
            return .never()
            
        case .longPressMainMandarat:
            
            // request edit screen
            listener.mainMandarat(editButtonClicked: position)
            
            return .never()
            
        default:
            return .just(action)
        }
    }
    
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .mandaratDataFromOutside(let mainMandaratRO):
            
            var newState = state
            newState.mandarat = mainMandaratRO
            
            return newState
        default:
            return state
        }
    }
}


// MARK: Public interface
extension MainMandaratViewModel {
    
    public func requestRender(_ mandaratRO: MainMandaratRO) {
        
        action.onNext(.mandaratDataFromOutside(mandaratRO))
    }
}


// MARK: State & Action
extension MainMandaratViewModel {
    
    enum Action {
        
        // Event
        case addMandaratButtonClicked
        case mainMandaratDisplayViewClicked
        case mandaratDataFromOutside(MainMandaratRO)
        case longPressMainMandarat
        
        // Side effect
        
    }
    
    struct State {
        
        var mandarat: MainMandaratRO?
        
        public var isAvailable: Bool { mandarat != nil }
        
    }
}
