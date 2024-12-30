//
//  MockUserStateRepository.swift
//  Home
//
//  Created by choijunios on 12/30/24.
//

import DomainUserStateInterface

public class MockUserStateUseCase: UserStateUseCase {
    
    private var memoryDict: [String: Any] = [:]
    
    public init() {
        
        BooleanUserStateKey.allCases.forEach { key in
            
            memoryDict[key.rawValue] = key.initialValue
        }
    }
    
    public func checkState(_ key: DomainUserStateInterface.BooleanUserStateKey) -> Bool {
        memoryDict[key.rawValue] as! Bool
    }
    
    public func toggleState(_ key: DomainUserStateInterface.BooleanUserStateKey) {
        
        let currentValue: Bool = memoryDict[key.rawValue] as! Bool
        
        memoryDict[key.rawValue] = !currentValue
    }
}
