//
//  SubMandaratVO.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

public struct SubMandaratVO {
    
    public let mainMandarat: MainMandaratVO
    
    public let title: String
    public let description: String?
    public let imageURL: String?
    public let position: MandaratPosition
    
    public var hexColor: String? {
        
        mainMandarat.hexColor
    }
}
