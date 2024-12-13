//
//  SubMandaratVO.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

public struct SubMandaratVO {
    
    public let title: String
    public let description: String?
    public let imageURL: String?
    public let position: MandaratPosition
    
    public init(
        title: String,
        description: String?,
        imageURL: String?,
        position: MandaratPosition
    ) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.position = position
    }
}
