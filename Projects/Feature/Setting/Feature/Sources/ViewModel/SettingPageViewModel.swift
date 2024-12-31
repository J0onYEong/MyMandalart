//
//  SettingPageViewModel.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import ReactorKit

protocol SettingPageRouting: AnyObject {
    
    
}

public protocol SettingPageViewModelListener: AnyObject {
    
    func settingPageFinished()
}

class SettingPageViewModel: Reactor, SettingPageViewModelable, SettingItemRowViewModelListener {
    
    // Router
    weak var router: SettingPageRouting?
    
    
    // Listener
    weak var listener: SettingPageViewModelListener?
    
    
    var initialState: State = .init(rowItemViewModel: [])
    
    
    init() {
        
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
        
    }
}
