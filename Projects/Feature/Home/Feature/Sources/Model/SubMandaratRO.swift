//
//  SubMandaratRO.swift
//  Home
//
//  Created by choijunios on 12/24/24.
//

import UIKit

import DomainMandaratInterface

struct SubMandaratRO {
    
    let title: String
    let percent: CGFloat
    let primaryColor: UIColor
    
    static func create(vo: SubMandaratVO, primaryColor color: UIColor) -> Self {
        
        return .init(
            title: vo.title,
            percent: vo.acheivementRate,
            primaryColor: color
        )
    }
}
