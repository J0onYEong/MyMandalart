//
//  StringUserStateKey.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

public enum StringUserStateKey: String, UserStateKey {
    
    case userNickName
    
    public var initialValue: Any {
        
        switch self {
        case .userNickName:
            String("")
        }
    }
}
