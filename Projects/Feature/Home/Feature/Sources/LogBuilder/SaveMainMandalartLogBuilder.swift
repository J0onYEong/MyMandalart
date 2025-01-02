//
//  SaveMainMandalartLogBuilder.swift
//  Home
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

import DomainMandaratInterface

class SaveMainMandalartLogBuilder: LogObjectBuilder<LogObject> {
    
    init(
        id: String,
        title: String,
        description: String?,
        position: MandaratPosition,
        paletteType: String
    ) {
        super.init(eventType: "save_main_mandarat")
        
        setProperty(key: "main_mandalart_id", value: id)
        setProperty(key: "main_mandalart_title", value: title)
        
        if let description {
            setDescription(description)
        }
            
        
        let (x, y) = position.matrixCoordinate
        let positionText = "\(x):\(y)"
        
        
        setProperty(key: "main_mandarat_position", value: positionText)
        setProperty(key: "palette_type", value: paletteType)
    }
    
    
    func setDescription(_ text: String) {
        setProperty(key: "main_mandalart_description", value: text)
    }
}
