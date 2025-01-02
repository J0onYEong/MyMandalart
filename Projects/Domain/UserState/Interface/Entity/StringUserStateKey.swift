//
//  StringUserStateKey.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

import Foundation

public enum StringUserStateKey: String, UserStateKey {
    
    case userNickName
    
    case deviceId
    
    public var initialValue: Any {
        
        switch self {
        case .deviceId:
            UUID().uuidString
        case .userNickName:
            String("")
        }
    }
}
