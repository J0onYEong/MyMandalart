//
//  BooleanUserStateKey.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

public enum BooleanUserStateKey: String, UserStateKey {
    
    // Onboading
    case onboarding_edit_saved_mandarat
    case onboarding_exit_submandarat_page
    
    
    // Loging
    case log_initial_nickname_creation
    case log_initial_main_mandalart_creation
    case log_initial_sub_mandalart_creation
    
    
    public var initialValue: Any {
        
        switch self {
        default:
            return false
        }
    }
}
