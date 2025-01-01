//
//  ColorSet.swift
//  Home
//
//  Created by choijunios on 1/1/25.
//

import UIKit

import SharedPresentationExt

struct ColorSet {
    
    public let primaryColor: UIColor
    public let secondColor: UIColor
    
    init(primaryColor: UIColor, secondColor: UIColor = .white) {
        self.primaryColor = primaryColor
        self.secondColor = secondColor
    }
    
    init(primaryHex: String, secondHex: String? = nil) {
        
        self.primaryColor = .color(primaryHex)!
        
        if let secondHex {
            self.secondColor = .color(secondHex)!
        } else {
            self.secondColor = .white
        }
    }
}
