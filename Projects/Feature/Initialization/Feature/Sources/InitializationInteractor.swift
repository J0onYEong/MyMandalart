//
//  InitializationInteractor.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import DomainUserStateInterface

enum TransitionStyle {
    case `default`
    case opacity
}

protocol InitializationRouting: AnyObject {
    
    func presentMainMandaratPage(style: TransitionStyle)
    
    func presentNickNameInputPage()
}

class InitializationInteractor: InitializationInteractable, NickNameInputPageViewModelListener {
    
    // DI
    private let userStateUseCase: UserStateUseCase
    
    
    // Router
    weak var router: InitializationRouting?
    
    
    init(userStateUseCase: UserStateUseCase) {
        self.userStateUseCase = userStateUseCase
    }
    
}

// MARK: InitializationInteractable
extension InitializationInteractor {
    
    func startInitialFlow() {
        
        let userNickName = userStateUseCase.checkState(.userNickName)
        
        if userNickName.isEmpty {
            
            router?.presentNickNameInputPage()
            
        } else {
            
            router?.presentMainMandaratPage(style: .opacity)
        }
    }
}


// MARK: NickNameInputPageViewModelListener
extension InitializationInteractor {
    
    func nickInputPageFinish(nickName: String) {
        
        userStateUseCase.setState(.userNickName, value: nickName)
        
        router?.presentMainMandaratPage(style: .default)
    }
}
