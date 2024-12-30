//
//  DefaultUserStateRepository.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

import Foundation

import DataUserStateInterface

public class DefaultUserStateRepository: UserStateRepository {
    
    private let localStorage: UserDefaults = .standard
    private var memoryStorage: [String: Any] = [:]
    
    private let serialQueue: DispatchQueue = .init(label: "com.DefaultUserStateRepository")
    
    private let dictKey = "UserState"
    
    public init() {
        
        fetchUserState()
    }
    
    public subscript(key: UserStateKey) -> Bool {
        get {
            serialQueue.sync {
                memoryStorage[key.rawValue] as! Bool
            }
        }
        set {
            serialQueue.async { [weak self] in
                guard let self else { return }
                memoryStorage[key.rawValue] = newValue
                saveCurrentDict()
            }
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
            
            if let dict = localStorage.dictionary(forKey: dictKey) {
                
                dict.forEach({ key, value in
                    
                    memoryStorage[key] = value
                })
                
            } else {
                
                UserStateKey.allCases.forEach { key in
                    
                    memoryStorage[key.rawValue] = key.initialValue
                }
            }
        }
    }
}
