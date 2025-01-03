//
//  EditMainMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import SharedDesignSystem
import SharedPresentationExt
import SharedLoggerInterface
import SharedCore

import DomainMandaratInterface

import ReactorKit
import RxSwift

class EditMainMandaratViewModel: NSObject, Reactor, UIColorPickerViewControllerDelegate {
    
    // DI
    private let logger: Logger
    
    
    let initialState: State
    
    weak var listener: EditMainMandaratViewModelListener?
    
    private let initialMandarat: MainMandaratVO
    
    init(logger: Logger, mainMandaratVO: MainMandaratVO) {
        
        self.logger = logger
        self.initialMandarat = mainMandaratVO
        
        
        // Set initial state
        let palette = MandalartPalette(identifier: mainMandaratVO.colorSetId)
        
        self.initialState = .init(
            titleText: mainMandaratVO.title,
            descriptionText: mainMandaratVO.description ?? "",
            palette: palette
        )
    }
    
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .exitButtonClicked:
            
            listener?.editFinished()
            
            return .empty()
            
        case .saveButtonClicked:
            
            let titleValidationResult = validateTitle(currentState.titleText)
            
            if titleValidationResult {
                
                return .just(.finishEditPage)
                
            } else {
                
                let toatData: ToastData = .init(
                    title: "만다라트 저장 실패",
                    description: "만다라트의 제목은 1자 이상이어야 합니다!",
                    alertColor: .color("#FB4141")
                )
                
                return .just(.presentToastView(data: toatData))
            }

        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        var newState = state
        
        switch mutation {
        case .editTitleText(let text):
            newState.titleText = text
            
        case .editDescriptionText(let text):
            newState.descriptionText = text
            
        case .paletteIsSelected(let palette):
            newState.palette = palette
            
            // 선택된 팔레트 로깅
            logImmediateSelectedPalette(paletteType: palette.identifier)
            
        case .finishEditPage:
            
            let mandaratVO: MainMandaratVO = createMandaratVO(state: state)
            listener?.editFinishedWithSavingRequest(edited: mandaratVO)
            
        case .presentToastView(let toastData):
            
            newState.toastData = toastData
            
        default:
            break
        }
        
        return newState
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
        case paletteIsSelected(paletteType: MandalartPalette)
        case finishEditPage
        case presentToastView(data: ToastData)
        
        // - editing
        case editTitleText(text: String)
        case editDescriptionText(text: String)
        
        // - touch
        case exitButtonClicked
        case saveButtonClicked
    }
    
    
    struct State {
        
        var titleText: String
        var descriptionText: String
        var exitPageTrigger: Bool = false
        
        var palette: MandalartPalette = .type1
        
        // alert
        var toastData: ToastData? = nil
    }
    
    
    struct ToastData: Equatable {
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
            colorSetId: state.palette.identifier,
            description: state.descriptionText,
            imageURL: nil
        )
        
        return newMandarat
    }
}


// MARK: Logging
extension EditMainMandaratViewModel {
    
    func logImmediateSelectedPalette(paletteType: String) {
        
        let builder = ImmediateSelectedPaletteLogBuilder(
            paletteType: paletteType
        )
        
        let logObject = builder.build()
        
        logger.send(logObject)
    }
}
