//
//  EditSubMandartViewModel.swift
//  Home
//
//  Created by choijunios on 12/20/24.
//

import UIKit

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
            
            router.dismissEditSubMandaratPage()
            
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
            
            let titleText: String = state.titleText
            
            if validateInput(titleText: titleText) {
                
                // 인풋 검증 통과
                
                let subMandaratVO: SubMandaratVO = createSubmandarat(state)
                listener.editFinishedWithSavingRequest(edited: subMandaratVO)
                
                router.dismissEditSubMandaratPage()
                
                return state
                
            } else {
                
                // 인풋 검증 불통
                
                var newState = state
                newState.alertData = .init(
                    title: "저장 실패",
                    description: "제목은 1자 이상이어야 합니다!",
                    alertColor: .color("#FB4141")
                )
                
                return newState
            }
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
            id: initialSubMandartVO.id,
            title: state.titleText,
            acheivementRate: state.acheiveRate,
            position: position
        )
    }
}


// MARK: Reactor
extension EditSubMandartViewModel {
    
    enum Action {
           
        case acheivePercentChanged(percent: Double)
        case titleChanged(text: String)
        case saveButtonClicked
        case exitButtonClicked
    }
    
    
    struct State {
        
        var titleText: String
        var acheiveRate: Double
        
        // alert
        var alertData: AlertData? = nil
    }
    
    
    struct AlertData: Equatable {
        let id = UUID()
        let title: String
        let description: String?
        let alertColor: UIColor?
    }
}


// MARK: Content validation
private extension EditSubMandartViewModel {
    
    func validateInput(titleText: String) -> Bool {
        
        return !titleText.isEmpty
    }
}
