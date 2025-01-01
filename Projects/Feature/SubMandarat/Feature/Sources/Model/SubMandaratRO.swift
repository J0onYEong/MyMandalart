//
//  SubMandaratRO.swift
//  SubMandarat
//
//  Created by choijunios on 12/24/24.
//

import UIKit

import SharedDesignSystem

import DomainMandaratInterface

struct SubMandaratRO {
    
    let title: String
    let percent: CGFloat
    
    let backgroundColor: UIColor
    let backgroundSubColor: UIColor
    let titleTextColor: UIColor
    let subTextColor: UIColor
    
    let gageColor: UIColor
    let gageBackgroundColor: UIColor
    
    var percentText: String {
        
        let rounded = (percent * 100).rounded()
        return "목표 달성율: \(rounded)%"
    }
    
    static func create(vo: SubMandaratVO, palette: MandalartPalette) -> Self {
        
        return .init(
            title: vo.title,
            percent: vo.acheivementRate,
            backgroundColor: palette.backgroundColor.primaryColor,
            backgroundSubColor: palette.backgroundColor.secondColor,
            titleTextColor: palette.textColor.primaryColor,
            subTextColor: palette.textColor.secondColor,
            gageColor: palette.gageColor.primaryColor,
            gageBackgroundColor: palette.gageColor.secondColor
        )
    }
}
