//
//  LogObjectBuildable.swift
//  Logger
//
//  Created by choijunios on 1/2/25.
//

public protocol LogObjectBuildable {
    
    associatedtype LogObject: LogObjectable
    
    func build() -> LogObject
}
