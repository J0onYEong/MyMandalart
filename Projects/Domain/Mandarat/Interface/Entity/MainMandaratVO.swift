//
//  MainMandaratVO.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

import Foundation

public struct MainMandaratVO: Identifiable {
    
    public let id: String
    
    public let title: String
    public let position: MandaratPosition
    
    public let colorSetId: String
    public let description: String?
    public let imageURL: String?
    
    public init(id: String = UUID().uuidString, title: String, position: MandaratPosition, colorSetId: String, description: String?, imageURL: String?) {
        
        self.id = id
        self.title = title
        self.position = position
        self.colorSetId = colorSetId
        self.description = description
        self.imageURL = imageURL
    }
    
    public static func createEmpty(with position: MandaratPosition) -> Self {
        
        return .init(
            title: "",
            position: position,
            colorSetId: "type1",
            description: nil,
            imageURL: nil
        )
    }
}
