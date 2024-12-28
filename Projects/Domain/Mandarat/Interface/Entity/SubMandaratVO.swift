//
//  SubMandaratVO.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

import Foundation

public struct SubMandaratVO {
    
    public let id: String
    public let title: String
    public let acheivementRate: Double
    public let position: MandaratPosition
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        acheivementRate: Double,
        position: MandaratPosition
    ) {
        self.id = id
        self.title = title
        self.acheivementRate = acheivementRate
        self.position = position
    }
    
    public static func createEmpty(with position: MandaratPosition) -> Self {
        
        return .init(
            title: "",
            acheivementRate: 0.0,
            position: position
        )
    }
}
