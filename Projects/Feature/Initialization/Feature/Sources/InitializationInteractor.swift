//
//  InitializationInteractor.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import DomainUserStateInterface

import SharedLoggerInterface

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
    private let logger: Logger
    
    
    // Router
    weak var router: InitializationRouting?
    
    
    init(userStateUseCase: UserStateUseCase, logger: Logger) {
        self.userStateUseCase = userStateUseCase
        self.logger = logger
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
        
        if !userStateUseCase.checkState(.log_initial_nickname_creation) {
            
            self.logInitialNickNameCreation()
            
            userStateUseCase.toggleState(.log_initial_nickname_creation)
        }
        
        router?.presentMainMandaratPage(style: .default)
    }
}


// MARK: Logging
private extension InitializationInteractor {
    
    func logInitialNickNameCreation() {
        
        let builder = DefaultLogObjectBuilder(eventType: "make_initial_user_nickname")
        let object = builder.build()
        
        logger.send(object)
    }
}
