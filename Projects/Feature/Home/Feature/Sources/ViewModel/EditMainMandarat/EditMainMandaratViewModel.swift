//
//  EditMainMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import SharedPresentationExt
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
            
            router.dismissEditMainMandaratPage()
            
            return .empty()
            
        case .saveButtonClicked:
            
            return state
                .map(\.titleText)
                .withUnretained(self)
                .map { viewModel, titleText in
                    
                    if viewModel.validateTitle(titleText) {
                        
                        // 유효한 타이틀
                        return .saveMainMandarat
                    }
                    
                    return .alert(.init(
                        title: "만다라트 저장 실패",
                        description: "만다라트의 제목은 1자 이상이어야 합니다!",
                        alertColor: .color("#FB4141")
                    ))
                }
            
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
            
        case .saveMainMandarat:
            
            let mandaratVO: MainMandaratVO = createMandaratVO(state: state)
            
            delegate.editFinishedWithSavingRequest(edited: mandaratVO)
            
            router.dismissEditMainMandaratPage()
            
            return state
            
        case .alert(let alertData):
            
            var newState = state
            
            newState.alertData = alertData
            newState.presentAlert = true
            
            return newState
            
        case .alertFinished:
            
            var newState = state
            
            newState.alertData = nil
            newState.presentAlert = false
            
            return newState
            
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
        case saveMainMandarat
        case alert(AlertData)
        case alertFinished
        
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
        
        // alert
        var presentAlert: Bool = false
        var alertData: AlertData? = nil
    }
    
    struct AlertData {
        let title: String
        let description: String?
        let alertColor: UIColor?
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
