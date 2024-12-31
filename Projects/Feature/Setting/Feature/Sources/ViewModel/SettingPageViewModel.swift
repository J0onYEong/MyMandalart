//
//  SettingPageViewModel.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import Foundation

import DomainUserStateInterface

import ReactorKit

protocol SettingPageRouting: AnyObject {
        
    func presentEditNickNamePage()
    
    func popEditNickNamePage()
    
    func openWebPage(url: URL)
}

public protocol SettingPageViewModelListener: AnyObject {
    
    func settingPageFinished()
    
    func nickNameUpdated(_ nickName: String)
}

class SettingPageViewModel: Reactor, SettingPageViewModelable, SettingItemRowViewModelListener, EditNickNamePageViewModelListener {
    
    // DI
    private let userStateUseCase: UserStateUseCase
    
    
    // Router
    weak var router: SettingPageRouting?
    
    
    // Listener
    weak var listener: SettingPageViewModelListener?
    
    
    var initialState: State
    
    
    init(listener: SettingPageViewModelListener, userStateUseCase: UserStateUseCase) {
        
        self.listener = listener
        self.userStateUseCase = userStateUseCase
        self.initialState = .init(rowItemViewModel: [])
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        var newState = state
        
        switch mutation {
        case .viewDidLoad:
            
            newState.rowItemViewModel = createSettingRowItemViewModel()
            
        case .backButtonClicked:
            
            listener?.settingPageFinished()
        }
        
        return newState
    }
    
}


// MARK: Reactor
extension SettingPageViewModel {
    
    enum Action {
        case viewDidLoad
        case backButtonClicked
    }
    
    struct State {
        var rowItemViewModel: [SettingItemRowViewModel]
    }
}


// MARK: Create setting row item view model
extension SettingPageViewModel {
    
    func createSettingRowItemViewModel() -> [SettingItemRowViewModel] {
        
        SettingItemRowType.rowOrder.map { itemType in
            
            let viewModel = SettingItemRowViewModel(type: itemType)
            viewModel.listener = self
            
            return viewModel
        }
    }
}


// MARK: SettingItemRowViewModelListener
extension SettingPageViewModel {
    
    func presentNickNameEditPage() {
        
        router?.presentEditNickNamePage()
    }
}


// MARK: EditNickNamePageViewModelListener
extension SettingPageViewModel {
    
    func nickInputPageFinish(nickName: String?) {
        
        if let nickName {
            
            userStateUseCase.setState(.userNickName, value: nickName)
            
            listener?.nickNameUpdated(nickName)
        }
        
        router?.popEditNickNamePage()
    }
}
