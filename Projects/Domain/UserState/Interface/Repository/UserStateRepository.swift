//
//  UserStateRepository.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

public protocol UserStateRepository: AnyObject {
    
    func initializeBeforeFetch(keys: [any UserStateKey])
    
    func set(key: String, value: Any)
    
    func get<Value>(key: String) -> Value
}
