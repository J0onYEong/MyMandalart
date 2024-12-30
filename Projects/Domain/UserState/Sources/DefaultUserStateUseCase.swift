//
//  DefaultUserStateUseCase.swift
//  UserState
//
//  Created by choijunios on 12/30/24.
//

import DomainUserStateInterface

public class DefaultUserStateUseCase: UserStateUseCase {
    
    private let userStateRepository: UserStateRepository
    
    public init(userStateRepository: UserStateRepository) {
        self.userStateRepository = userStateRepository
    }
    
    public func checkState(_ key: BooleanUserStateKey) -> Bool {
        
        userStateRepository.get(key: key.rawValue)
    }
    
    public func toggleState(_ key: BooleanUserStateKey) {
        
        let currentValue: Bool = userStateRepository.get(key: key.rawValue)
        
        userStateRepository.set(key: key.rawValue, value: !currentValue)
    }
}
