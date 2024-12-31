//
//  EditNickNamePageViewModel.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import ReactorKit

protocol EditNickNamePageViewModelListener: AnyObject {
    
    func nickInputPageFinish(nickName: String)
}


class EditNickNamePageViewModel: Reactor {
    
    weak var listener: EditNickNamePageViewModelListener?
    
    var initialState: State
    
    init() {
        
        self.initialState = .init()
    }
    
    
    func reduce(state: State, mutation: Action) -> State {
        switch mutation {
        case .editNickName(let text):
            
            var newState = state
            
            let isValid = nickNameValidation(text)
            newState.setNickName(text)
            newState.completeButtonEnabled = isValid
            
            return newState
            
        case .completeButtonClicked:
            
            listener?.nickInputPageFinish(nickName: state.getNickName())
            
            return state
            
        default:
            return state
        }
    }
}


// MARK: Reactor
extension EditNickNamePageViewModel {
    
    struct State {
        
        private var nickName: String = ""
        var completeButtonEnabled: Bool = false
        
        mutating func setNickName(_ text: String) {
            self.nickName = text
        }
        func getNickName() -> String { self.nickName }
    }
    
    enum Action {
        
        case editNickName(text: String)
        case completeButtonClicked
    }
}



extension EditNickNamePageViewModel {
    
    func nickNameValidation(_ text: String) -> Bool {
        
        return text.count >= 3
    }
}
