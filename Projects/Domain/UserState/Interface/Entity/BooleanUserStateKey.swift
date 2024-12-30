//
//  BooleanUserStateKey.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

public enum BooleanUserStateKey: String, UserStateKey {
    
    case onboarding_edit_saved_mandarat
    case onboarding_exit_submandarat_page
    
    public var initialValue: Any {
        
        switch self {
        case .onboarding_edit_saved_mandarat:
            false
        case .onboarding_exit_submandarat_page:
            false
        }
    }
}
