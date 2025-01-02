//
//  UserNickNameLogBuilder.swift
//  Initialization
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

class UserNickNameLogBuilder: LogObjectBuildable {
    
    public let eventType: String = "make_initial_user_nickname"
    private var properties: [String: Any] = [:]
    
    init(_ nickName: String) {
        
        self.properties["user_nick_name"] = nickName
    }
    
    func build() -> LogObject {
        
        return .init(
            eventType: eventType,
            properties: properties
        )
    }
}
