//
//  SubMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import SharedDesignSystem

import DomainMandaratInterface

import ReactorKit
import RxSwift

class SubMandaratViewModel: Reactor {
    
    var initialState: State
    
    private let position: MandaratPosition
    
    weak var listener: SubMandaratViewModelListener!
    
    init(position: MandaratPosition, palette: MandalartPalette) {
        
        self.position = position
        
        self.initialState = .init(palette: palette)
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .editSubMandaratButtonClicked:
            
            listener.subMandarat(edit: position)
            return .never()
            
        case .longPress:
            
            listener.subMandarat(edit: position)
            return .never()
            
        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .mandaratDataFromOutside(let title, let percent):
            
            var newState = state
            newState.titleText = title
            newState.acheivementRate = percent
            newState.isAvailable = true
            
            return newState
            
        default:
            return state
        }
    }
}


// MARK: public interface
extension SubMandaratViewModel {
    
    func render(title: String, acheivementRate: Double) {
        
        action.onNext(.mandaratDataFromOutside(
            title: title,
            acheivementRate: acheivementRate
        ))
    }
}


// MARK: Reactor
extension SubMandaratViewModel {
    
    enum Action {
        
        case editSubMandaratButtonClicked
        case mandaratDataFromOutside(title: String, acheivementRate: Double)
        case longPress
    }
    
    struct State {
        
        var isAvailable: Bool = false
        
        var titleText: String! = nil
        var acheivementRate: Double! = nil
        
        var palette: MandalartPalette
    }
}
