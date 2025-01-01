//
//  NickNameInputPageViewModel.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import ReactorKit

protocol NickNameInputPageViewModelListener: AnyObject {
    
    func nickInputPageFinish(nickName: String)
}


class NickNameInputPageViewModel: Reactor {
    
    weak var listener: NickNameInputPageViewModelListener?
    
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
extension NickNameInputPageViewModel {
    
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



extension NickNameInputPageViewModel {
    
    func nickNameValidation(_ text: String) -> Bool {
        
        return text.count >= 3
    }
}
