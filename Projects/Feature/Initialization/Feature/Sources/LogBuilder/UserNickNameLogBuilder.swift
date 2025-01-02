//
//  UserNickNameLogBuilder.swift
//  Initialization
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

class UserNickNameLogBuilder: LogObjectBuilder<LogObject> {
    
    init(_ nickName: String) {
        
        super.init(eventType: "make_initial_user_nickname")
        
        self.setProperty(
            key: "user_nick_name",
            value: nickName
        )
    }
    
    override func build() -> LogObject {
        
        return .init(
            eventType: eventType,
            properties: properties
        )
    }
}
