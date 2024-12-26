//
//  SubMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import DomainMandaratInterface

import ReactorKit
import RxSwift

class SubMandaratViewModel: Reactor {
    
    var initialState: State
    
    private let position: MandaratPosition
    
    weak var listner: SubMandaratViewModelListener!
    
    init(position: MandaratPosition, color: UIColor) {
        
        self.position = position
        
        self.initialState = .init(
            titleColor: color
        )
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .editSubMandaratButtonClicked:
            
            listner.subMandarat(edit: position)
            return .never()
            
        case .longPress:
            
            listner.subMandarat(edit: position)
            return .never()
            
        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .mandaratDataFromOutside(let subMandaratRO):
            
            var newState = state
            newState.renderObject = subMandaratRO
            newState.isAvailable = true
            
            return newState
            
        default:
            return state
        }
    }
}


// MARK: public interface
extension SubMandaratViewModel {
    
    func render(object: SubMandaratRO) {
        
        action.onNext(.mandaratDataFromOutside(object))
    }
}


// MARK: Reactor
extension SubMandaratViewModel {
    
    enum Action {
        
        case editSubMandaratButtonClicked
        case mandaratDataFromOutside(SubMandaratRO)
        case longPress
    }
    
    struct State {
        
        var isAvailable: Bool = false
        var titleColor: UIColor
        
        var renderObject: SubMandaratRO?
    }
}
