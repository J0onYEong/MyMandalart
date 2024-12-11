//
//  MainMandaratVO.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

import Foundation

public struct MainMandaratVO: Identifiable {
    
    public let id: String = UUID().uuidString
    
    public let title: String
    public let position: MandaratPosition
    
    public let hexColor: String?
    public let description: String?
    public let imageURL: String?
    
    public init(title: String, position: MandaratPosition, hexColor: String?, description: String?, imageURL: String?) {
        
        self.title = title
        self.position = position
        self.hexColor = hexColor
        self.description = description
        self.imageURL = imageURL
    }
    
    public static func createEmpty(with position: MandaratPosition) -> Self {
        
        return .init(
            title: "",
            position: position,
            hexColor: nil,
            description: nil,
            imageURL: nil
        )
    }
}
