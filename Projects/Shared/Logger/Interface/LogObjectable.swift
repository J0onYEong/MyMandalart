//
//  LogObjectable.swift
//  Logger
//
//  Created by choijunios on 1/2/25.
//

public protocol LogObjectable {
    
    var eventType: String { get }
    var properties: [String: Any] { get }
}

public extension LogObjectable {
    
    var description: String {
        
        """
        [이벤트 타입] : \(eventType)
        
        [매개 변수]
        \(properties)
        """
    }
}
