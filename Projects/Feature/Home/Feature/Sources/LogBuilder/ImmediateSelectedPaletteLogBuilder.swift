//
//  ImmediateSelectedPaletteLogBuilder.swift
//  Home
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

class ImmediateSelectedPaletteLogBuilder: LogObjectBuilder<LogObject> {
    
    init(paletteType: String) {
        super.init(eventType: "immediate_selected_palette")
        
        setProperty(
            key: "palette_type",
            value: paletteType
        )
    }
}
