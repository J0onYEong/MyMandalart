//
//  LogObjectBuildable.swift
//  Logger
//
//  Created by choijunios on 1/2/25.
//

public protocol LogObjectBuildable {
    
    associatedtype Object: LogObject
    
    func build() -> Object
}

public struct DefaultLogObjectBuilder: LogObjectBuildable {
    
    public let eventType: String
    public private(set) var properties: [String: Any] = [:]
    
    public mutating func setProperty(key: String, value: Any) {
        
        self.properties[key] = value
    }
    
    public func build() -> LogObject {
        
        return .init(
            eventType: eventType,
            properties: properties
        )
    }
}
