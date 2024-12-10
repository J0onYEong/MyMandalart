//
//  AlertModel.swift
//  Home
//
//  Created by choijunios on 12/10/24.
//

import UIKit

struct AlertModel {
    
    let title: String
    let description: String?
    var alertActions: [UIAlertAction] = [
        .init(title: "닫기", style: .default)
    ]
    
    init(title: String, description: String?, alertActions: [UIAlertAction]) {
        self.title = title
        self.description = description
        self.alertActions = alertActions
    }
}
