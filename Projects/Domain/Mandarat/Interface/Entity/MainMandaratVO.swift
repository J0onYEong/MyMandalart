//
//  MainMandaratVO.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

public struct MainMandaratVO: Identifiable {
    
    public let id: String
    
    public let title: String
    public let position: MandaratPosition
    
    public let hexColor: String?
    public let description: String?
    public let imageURL: String?
    
    public init(id: String, title: String, position: MandaratPosition, hexColor: String?, description: String?, imageURL: String?) {
        self.id = id
        self.title = title
        self.position = position
        self.hexColor = hexColor
        self.description = description
        self.imageURL = imageURL
    }
}
