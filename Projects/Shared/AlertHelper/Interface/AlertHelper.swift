//
//  AlertHelper.swift
//  AlertHelper
//
//  Created by choijunios on 12/10/24.
//

import UIKit

import SharedNavigationInterface

private protocol AlertHelperProtocol {
    
    func presentAlert(model: AlertModel)
}

public class AlertHelper: AlertHelperProtocol {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func presentAlert(model: SharedAlertHelperInterface.AlertModel) {
        
        let alertController: UIAlertController = .init(
            title: model.title,
            message: model.description,
            preferredStyle: .alert
        )
        
        model.alertActions.forEach { action in
            alertController.addAction(action)
        }
        router.present(alertController, animated: true, modalPresentationSytle: .automatic)
    }
}
