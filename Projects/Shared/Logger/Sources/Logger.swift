//
//  Logger.swift
//  Logger
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

public class DefaultLogger: Logger {
    
    
}


// MARK: Logger
public extension DefaultLogger {
    
    func send(_ log: LogObjectable) {
        
        print(log.description)
        
        // send log
    }
}
