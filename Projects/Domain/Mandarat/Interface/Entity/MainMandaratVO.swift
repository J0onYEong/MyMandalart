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
}
