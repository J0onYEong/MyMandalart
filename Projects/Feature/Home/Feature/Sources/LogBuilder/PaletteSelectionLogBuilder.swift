//
//  PaletteSelectionLogBuilder.swift
//  Home
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

class PaletteSelectionLogBuilder: LogObjectBuilder<LogObject> {
    
    init(paletteType: String) {
        super.init(eventType: "save_with_palette")
        
        setProperty(
            key: "palette_type",
            value: paletteType
        )
    }
}
