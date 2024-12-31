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
    
    
}

class SettingPageViewModel: Reactor, SettingPageViewModelable {
    
    // Router
    weak var router: SettingPageRouting?
    
    
    // Listener
    weak var listener: SettingPageViewModelListener?
    
    
    var initialState: State
    
    
    init() {
        initialState = .init()
    }
    
}


// MARK: Reactor
extension SettingPageViewModel {
    
    enum Action {
        
    }
    
    struct State {
        
        
    }
}
