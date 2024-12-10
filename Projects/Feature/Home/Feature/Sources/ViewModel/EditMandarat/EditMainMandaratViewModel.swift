//
//  EditMainMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import DomainMandaratInterface

import ReactorKit
import RxSwift

class EditMainMandaratViewModel: NSObject, Reactor, UIColorPickerViewControllerDelegate {
    
    let initialState: State
    
    override init() {
        
        // Set initial state
        self.initialState = .init(
            titleText: "",
            descriptionText: "",
            mandaratTitleColor: .white
        )
    }
    
    public func editWithPreviousData(_ mainMandaratVO: MainMandaratVO?) {
        action.onNext(.editRequestFromOutside(mainMandarat: mainMandaratVO))
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .exitButtonClicked:
            
            let alertModel: AlertModel = .init(
                title: "메인 만다라트 작성 종료",
                description: "작성중이던 내용은 삭제됩니다.",
                alertActions: [
                    .init(title: "머무르기", style: .default),
                    .init(title: "나가기", style: .destructive, handler: { [weak self] _ in
                        // 화면 이탈
                        self?.action.onNext(.exitPage)
                    }),
                ]
            )
            return .just(.alert(alertModel))
            
        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .exitButtonClicked:
            
            var newState = state
            
            
            return newState
            
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
        
        // Side effect
        case alert(AlertModel)
        case exitPage
    }
    
    struct State {
        
        var titleText: String
        var descriptionText: String
        var mandaratTitleColor: UIColor
        var presentColorPicker: Bool = false
        var exitPageTrigger: Bool = false
    }
}

extension EditMainMandaratViewModel {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        
        action.onNext(.editColor(color: color))
    }
}
