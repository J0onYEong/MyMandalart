//
//  UserStateUseCase.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

import Foundation

public protocol UserStateUseCase {
    
    func checkState(_ key: BooleanUserStateKey) -> Bool
    func toggleState(_ key: BooleanUserStateKey)
    
    func checkState(_ key: StringUserStateKey) -> String
    func setState(_ key: StringUserStateKey, value: String)
}
