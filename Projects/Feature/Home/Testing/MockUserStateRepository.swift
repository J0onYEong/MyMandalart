//
//  MockUserStateRepository.swift
//  Home
//
//  Created by choijunios on 12/30/24.
//

import DataUserStateInterface

public class MockUserStateRepository: UserStateRepository {
    
    private var memoryDict: [String: Any] = [:]
    
    public init() {
        
        UserStateKey.allCases.forEach { key in
            
            memoryDict[key.rawValue] = key.initialValue
        }
    }
    
    public subscript(key: DataUserStateInterface.UserStateKey) -> Bool {
        get {
            memoryDict[key.rawValue] as! Bool
        }
        set(newValue) {
            memoryDict[key.rawValue] = newValue
        }
    }
}
