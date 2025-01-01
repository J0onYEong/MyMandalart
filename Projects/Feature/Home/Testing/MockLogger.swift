//
//  MockLogger.swift
//  Home
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

public class MockLogger: Logger {
    
    public init() { }
    
    public func send(_ log: SharedLoggerInterface.LogObject) {
        
        debugPrint(log.description)
    }
}
