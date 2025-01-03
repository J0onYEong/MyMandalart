//
//  FakeUserStateUseCase.swift
//  SubMandarat
//
//  Created by choijunios on 12/30/24.
//

import DomainUserStateInterface

public class FakeUserStateUseCase: UserStateUseCase {
    
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
    
    public func checkState(_ key: StringUserStateKey) -> String {
        
        return ""
    }
    
    public func setState(_ key: StringUserStateKey, value: String) {
        
        
    }
}
