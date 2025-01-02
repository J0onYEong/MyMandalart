//
//  LogObjectBuildable.swift
//  Logger
//
//  Created by choijunios on 1/2/25.
//

// MARK: LogObjectable
protocol LogObjectable {
    
    associatedtype Object: LogObject
    
    func build() -> Object
}


// MARK: LogObjectBuilder
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
        
        return LogObject(
            eventType: eventType,
            properties: properties) as! Object
    }
}


// MARK: DefaultLogObjectBuilder
public class DefaultLogObjectBuilder: LogObjectBuilder<LogObject> { }
