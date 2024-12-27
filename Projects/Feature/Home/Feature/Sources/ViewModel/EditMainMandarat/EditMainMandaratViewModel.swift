//
//  EditMainMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import DomainMandaratInterface
import SharedCore

import ReactorKit
import RxSwift

class EditMainMandaratViewModel: NSObject, Reactor, UIColorPickerViewControllerDelegate {
    
    let initialState: State
    
    weak var router: MainMandaratPageRouting!
    weak var delegate: EditMainMandaratViewModelDelegate!
    
    private let initialMandarat: MainMandaratVO
    
    init(_ mainMandaratVO: MainMandaratVO) {
        
        self.initialMandarat = mainMandaratVO
        
        let colorString = mainMandaratVO.hexColor
        
        // Set initial state
        self.initialState = .init(
            titleText: mainMandaratVO.title,
            descriptionText: mainMandaratVO.description ?? "",
            mandaratTitleColor: .color(colorString) ?? .white
        )
    }
    
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .exitButtonClicked:
            
            router.dismiss()
            
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
            newState.titleText = text
            
            return newState
        case .editColor(let color):
            
            var newState = state
            newState.mandaratTitleColor = color
            
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
            
            let mandaratVO: MainMandaratVO = createMandaratVO(state: state)
            
            delegate.editFinishedWithSavingRequest(edited: mandaratVO)
            
            router.dismiss()
            
            return state
            
        default:
            return state
        }
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
        case editColor(color: UIColor)
        
        // - touch
        case colorSelectionButtonClicked
        case exitButtonClicked
        case saveButtonClicked
    }
    
    struct State {
        
        var titleText: String
        var descriptionText: String
        var mandaratTitleColor: UIColor
        var presentColorPicker: Bool = false
        var exitPageTrigger: Bool = false
    }
}

private extension EditMainMandaratViewModel {
    
    func createMandaratVO(state: State) -> MainMandaratVO {
        
        let newMandarat: MainMandaratVO = .init(
            title: state.titleText,
            position: initialMandarat.position,
            hexColor: state.mandaratTitleColor.toHexString() ?? "#FFFFFF",
            description: state.descriptionText,
            imageURL: nil
        )
        
        return newMandarat
    }
}
