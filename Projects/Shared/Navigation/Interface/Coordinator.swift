//
//  Coordinator.swift
//  Navigation
//
//  Created by choijunios on 12/10/24.
//

import UIKit

public protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    
    var children: [Coordinator] { get set }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    
    func start()
}

public extension Coordinator {
    
    func addChild(_ child: Coordinator) {
        children.append(child)
    }
    
    func removeChild(_ child: Coordinator) {
        children.removeAll { coordinator in
            coordinator === child
        }
    }
}

public protocol CoordinatorFinishDelegate: AnyObject {
    
    func coordinator(finishedCoordinator: Coordinator)
}
