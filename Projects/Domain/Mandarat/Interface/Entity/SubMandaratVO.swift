//
//  SubMandaratVO.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

public struct SubMandaratVO {
    
    public let title: String
    public let acheivementRate: Double
    public let position: MandaratPosition
    
    public init(
        title: String,
        acheivementRate: Double,
        position: MandaratPosition
    ) {
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
