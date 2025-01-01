//
//  Logger.swift
//  Logger
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

public class DefaultLogger: Logger {
    
    public init() { }
}


// MARK: Logger
public extension DefaultLogger {
    
    func send(_ log: LogObject) {
        
        print(log.description)
        
        // send log
    }
}
