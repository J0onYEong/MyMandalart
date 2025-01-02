//
//  SaveSubMandalartLogBuilder.swift
//  SubMandarat
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

import DomainMandaratInterface

class SaveSubMandalartLogBuilder: LogObjectBuilder<LogObject> {
    
    
    init(
        mainMandalartId: String,
        subMandalartId: String,
        title: String,
        acheivementRate: Double,
        position: MandaratPosition,
        subMandalartCount: Int
    ) {
        
        super.init(eventType: "saved_sub_mandalart")
        
        
        setProperty(key: "main_mandalart_id", value: mainMandalartId)
        setProperty(key: "sub_mandalart_id", value: subMandalartId)
        setProperty(key: "sub_mandalart_title", value: title)
        
        
        let percentText = "\(Int(acheivementRate * 100))%"
        setProperty(key: "sub_mandalart_achievement_rate", value: percentText)
        
        
        let (x, y) = position.matrixCoordinate
        let positionText = "\(x):\(y)"
        setProperty(key: "sub_mandalart_position", value: positionText)
        setProperty(key: "saved_sub_mandalart_count", value: subMandalartCount)
    }
}
