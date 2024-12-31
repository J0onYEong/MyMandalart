//
//  MockUserStateUseCase.swift
//
//

import DomainUserStateInterface

public class MockUserStateUseCase: UserStateUseCase {
    
    private var memoryDict: [String: Any] = [:]
    
    public init() {
        
        BooleanUserStateKey.allCases.forEach { key in
            
            memoryDict[key.rawValue] = key.initialValue
        }
        
        memoryDict[StringUserStateKey.userNickName.rawValue] = "주니오스"
    }
    
    public func checkState(_ key: DomainUserStateInterface.BooleanUserStateKey) -> Bool {
        memoryDict[key.rawValue] as! Bool
    }
    
    public func toggleState(_ key: DomainUserStateInterface.BooleanUserStateKey) {
        
        let currentValue: Bool = memoryDict[key.rawValue] as! Bool
        
        memoryDict[key.rawValue] = !currentValue
    }
    
    public func checkState(_ key: StringUserStateKey) -> String {
        
        return memoryDict[key.rawValue] as! String
    }
    
    public func setState(_ key: StringUserStateKey, value: String) {
        
        memoryDict[key.rawValue] = value
    }
}
