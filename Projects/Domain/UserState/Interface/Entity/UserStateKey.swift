//
//  UserStateKey.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

public protocol UserStateKey: RawRepresentable<String>, CaseIterable {
    
    var initialValue: Any { get }
}

