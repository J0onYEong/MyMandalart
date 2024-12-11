//
//  MainMandaratRO.swift
//  Home
//
//  Created by choijunios on 12/11/24.
//

import UIKit

import DomainMandaratInterface
import SharedCore

struct MainMandaratRO: Equatable {
    
    let title: String
    let description: String
    let titleColor: UIColor
    
    static func create(from: MainMandaratVO) -> Self {
        
        let hexColorString = from.hexColor
        
        return .init(
            title: from.title,
            description: from.description ?? "",
            titleColor: hexColorString == nil ? .white : (.color(hexColorString!) ?? .white)
        )
    }
}

