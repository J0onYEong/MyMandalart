//
//  LogObjectBuildable.swift
//  Logger
//
//  Created by choijunios on 1/2/25.
//

protocol LogObjectable {
    
    associatedtype Object: LogObject
    
    func build() -> Object
}


open class LogObjectBuilder<Object: LogObject>: LogObjectable {
    
    public let eventType: String
    public private(set) var properties: [String: Any] = [:]
    
    public init(eventType: String) {
        self.eventType = eventType
    }
    
    public func setProperty(key: String, value: Any) {
        
        self.properties[key] = value
    }
    
    open func build() -> Object {
        fatalError()
    }
}


public class DefaultLogObjectBuilder: LogObjectBuilder<LogObject> {
    
    public override func build() -> LogObject {
        
        return .init(
            eventType: eventType,
            properties: properties
        )
    }
}
