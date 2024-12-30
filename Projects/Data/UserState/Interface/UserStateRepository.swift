//
//  UserStateRepository.swift
//  UserStateInterface
//
//  Created by choijunios on 12/30/24.
//

import Foundation

public protocol UserStateRepository {
    
    subscript (_ key: UserStateKey) -> Bool { get set }
}
