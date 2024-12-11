//
//  EditMainMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import SharedDependencyInjector
import SharedAlertHelperInterface
import SharedNavigationInterface
import DomainMandaratInterface

import ReactorKit
import RxSwift

class EditMainMandaratViewModel: NSObject, Reactor, UIColorPickerViewControllerDelegate {
    
    @Inject private var router: Router
    
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
            
            router.dismissModule(animated: true)
            
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

extension EditMainMandaratViewModel {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        
        action.onNext(.editColor(color: color))
    }
}
