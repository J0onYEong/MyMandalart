//
//  DefaultAlertHelper.swift
//  AlertHelper
//
//  Created by choijunios on 12/10/24.
//

import UIKit

import SharedAlertHelperInterface
import SharedNavigationInterface
import SharedDependencyInjector

public class DefaultAlertHelper: AlertHelper {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func presentAlertToTopViewController(model: SharedAlertHelperInterface.AlertModel) {
        
        let alertController: UIAlertController = .init()
        alertController.title = model.title
        alertController.message = model.description
        
        model.alertActions.forEach { action in
            alertController.addAction(action)
        }
        router.present(alertController, animated: false, modalPresentationSytle: .fullScreen)
    }
}
