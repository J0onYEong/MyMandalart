//
//  EditSubMandartViewModel.swift
//  Home
//
//  Created by choijunios on 12/20/24.
//

import Foundation

import DomainMandaratInterface

import ReactorKit
import RxSwift

class EditSubMandartViewModel: Reactor {
    
    // Listener
    weak var listener: EditSubMandaratViewModelListener!
    
    
    // Router
    weak var router: SubMandaratPageRouting!
    
    
    var initialState: State
    
    private let initialSubMandartVO: SubMandaratVO
    
    init(_ subMandartVO: SubMandaratVO) {
        
        self.initialSubMandartVO = subMandartVO
        
        self.initialState = .init(
            titleText: subMandartVO.title,
            acheiveRate: subMandartVO.acheivementRate
        )
    }
    
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .exitButtonClicked:
            
            router.dismiss()
            
            return .never()
        default:
            return .just(action)
        }
    }
    
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .acheivePercentChanged(let percent):
            
            var newState = state
            newState.acheiveRate = percent
            return newState
            
        case .titleChanged(let text):
            
            var newState = state
            newState.titleText = text
            return newState
            
        case .saveButtonClicked:
            
            let subMandaratVO: SubMandaratVO = createSubmandarat(state)
            listener.editFinishedWithSavingRequest(edited: subMandaratVO)
            
            router.dismiss()
                        
            return state
            
        default:
            return state
        }
    }
    
}


// MARK: Create sub vo
private extension EditSubMandartViewModel {
    
    func createSubmandarat(_ state: State) -> SubMandaratVO {
        
        let position: MandaratPosition = self.initialSubMandartVO.position
        
        return .init(
            title: state.titleText,
            acheivementRate: state.acheiveRate,
            position: position
        )
    }
}


// MARK: Reactor
extension EditSubMandartViewModel {
    
    struct State {
        
        var titleText: String
        var acheiveRate: Double
    }
    
    enum Action {
           
        case acheivePercentChanged(percent: Double)
        case titleChanged(text: String)
        case saveButtonClicked
        case exitButtonClicked
    }
}
