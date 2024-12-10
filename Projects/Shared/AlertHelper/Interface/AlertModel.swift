//
//  AlertModel.swift
//  AlertHelper
//
//  Created by choijunios on 12/10/24.
//

import UIKit

public struct AlertModel {
    
    public let title: String
    public let description: String?
    public private(set) var alertActions: [UIAlertAction] = [
        .init(title: "닫기", style: .default)
    ]
    
    public init(title: String, description: String?, alertActions: [UIAlertAction]) {
        self.title = title
        self.description = description
        self.alertActions = alertActions
    }
}
