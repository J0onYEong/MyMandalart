//
//  EditMainMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import SharedDesignSystem
import SharedPresentationExt
import SharedCore

import DomainMandaratInterface

import ReactorKit
import RxSwift

class EditMainMandaratViewModel: NSObject, Reactor, UIColorPickerViewControllerDelegate {
    
    let initialState: State
    
    weak var listener: EditMainMandaratViewModelListener!
    
    private let initialMandarat: MainMandaratVO
    
    init(_ mainMandaratVO: MainMandaratVO) {
        
        self.initialMandarat = mainMandaratVO
        
        let bundle = MandalartPaletteBundle(rawValue: mainMandaratVO.colorSetId)!
        
        // Set initial state
        self.initialState = .init(
            titleText: mainMandaratVO.title,
            descriptionText: mainMandaratVO.description ?? "",
            paletteType: bundle
        )
    }
    
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .exitButtonClicked:
            
            listener.editFinished()
            
            return .empty()

        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .editTitleText(let text):
            
            var newState = state
            newState.titleText = text
            
            return newState
            
        case .editDescriptionText(let text):
            
            var newState = state
            newState.descriptionText = text
            
            return newState
        case .editColor(let paletteType):
            
            var newState = state
            newState.paletteType = paletteType
            
            return newState
            
        case .colorSelectionButtonClicked:

            var newState = state
            newState.presentColorPicker = true
            
            return newState
            
        case .colorPickerClosed:
            
            var newState = state
            newState.presentColorPicker = false
            
            return newState
            
        case .saveButtonClicked:
            
            if validateTitle(state.titleText) {
                
                // 만다라트 저장 및 수정화면 종료
                
                let mandaratVO: MainMandaratVO = createMandaratVO(state: state)
                listener.editFinishedWithSavingRequest(edited: mandaratVO)
                
                return state
                
            } else {
                
                // 인풋 벨리데이션 통과 실패
                
                var newState = state
                newState.alertData = .init(
                    title: "만다라트 저장 실패",
                    description: "만다라트의 제목은 1자 이상이어야 합니다!",
                    alertColor: .color("#FB4141")
                )
                
                return newState
            }
            
        default:
            return state
        }
    }
}


// MARK: Input validation
extension EditMainMandaratViewModel {
    
    func validateTitle(_ text: String) -> Bool {
        
        return !text.isEmpty
    }
}


extension EditMainMandaratViewModel {
    
    enum Action {
        
        // Event
        case editRequestFromOutside(mainMandarat: MainMandaratVO?)
        case colorPickerClosed
        
        // - editing
        case editTitleText(text: String)
        case editDescriptionText(text: String)
        case editColor(paletteType: MandalartPaletteBundle)
        
        // - touch
        case colorSelectionButtonClicked
        case exitButtonClicked
        case saveButtonClicked
    }
    
    
    struct State {
        
        var titleText: String
        var descriptionText: String
        var presentColorPicker: Bool = false
        var exitPageTrigger: Bool = false
        
        var paletteType: MandalartPaletteBundle = .type1
        
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


private extension EditMainMandaratViewModel {
    
    func createMandaratVO(state: State) -> MainMandaratVO {
        
        
        let newMandarat: MainMandaratVO = .init(
            id: initialMandarat.id,
            title: state.titleText,
            position: initialMandarat.position,
            colorSetId: state.paletteType.identifier,
            description: state.descriptionText,
            imageURL: nil
        )
        
        return newMandarat
    }
}
