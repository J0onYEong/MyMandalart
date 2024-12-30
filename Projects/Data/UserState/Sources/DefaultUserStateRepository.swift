//
//  DefaultUserStateRepository.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

import Foundation

import DomainUserStateInterface

public class DefaultUserStateRepository: UserStateRepository {
    
    private let localStorage: UserDefaults = .standard
    private var memoryStorage: [String: Any] = [:]
    
    private let serialQueue: DispatchQueue = .init(label: "com.DefaultUserStateRepository")
    
    private let userStatKeys: [any UserStateKey] = [
        BooleanUserStateKey.allCases
    ].flatMap({ $0 })
    
    private let dictKey = "UserState"
    
    public init() {
        
        fetchUserState()
    }
    
    public func set(key: String, value: Any) {
        serialQueue.async { [weak self] in
            guard let self else { return }
            memoryStorage[key] = value
            saveCurrentDict()
        }
    }
    
    public func get<Value>(key: String) -> Value {
        serialQueue.sync {
            memoryStorage[key] as! Value
        }
    }
}


// MARK: Private
private extension DefaultUserStateRepository {
    
    /// 큐밖에서 실행됨 주의
    func saveCurrentDict() {
        serialQueue.async { [weak self] in
            guard let self else { return }
            localStorage.set(self.memoryStorage, forKey: dictKey)
        }
    }
    
    
    func fetchUserState() {
        
        serialQueue.sync {
            
            userStatKeys.forEach { key in
                
                memoryStorage[key.rawValue] = key.initialValue
            }
            
            if let dict = localStorage.dictionary(forKey: dictKey) {
                
                dict.forEach({ key, value in
                    
                    memoryStorage[key] = value
                })
                
            }
        }
    }
}
