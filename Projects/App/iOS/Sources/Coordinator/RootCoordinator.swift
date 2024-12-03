//
//  RootCoordinator.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import UIKit
import UseCase
import MainAppFeatures
import PresentationUtil

import Util

class DefaultRootCoordinator: RootCoordinator {
    
    var navigationController: UINavigationController
    
    var children: [Coordinator] = []
    weak var parent: (Coordinator)?
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
    
    func start() {
        
        let viewModel = RootViewModel()
        viewModel.presentNetworkConfigInputPage = { [weak self] in
            self?.presentNetworkConfigInputPage()
        }
        viewModel.presentMainTabBar = { [weak self] in
            self?.presentMainTabBar()
        }
        viewModel.presentClickToStartPage = { [weak self] in
            self?.presentClickToStartPage()
        }
        viewModel.presentChoosePlatformPage = { [weak self] in
            self?.presentChoosePlatformPage()
        }
        
        let viewController = RootViewController()
        viewController.bind(viewModel: viewModel)
        
        
        navigationController.pushViewController(
            viewController,
            animated: false
        )
    }
}

extension DefaultRootCoordinator {
    
    func presentNetworkConfigInputPage() {
        
        let coordinator = NetworkConfigSettingPageCoordinator(
            navigationController: navigationController
        )
        coordinator.finishDelegate = self
        addChild(coordinator)
        coordinator.start()
    }
    
    func presentMainTabBar() {
        
        let coordinator = MainScreenCoordinator(
            navigationController: navigationController
        )
        
        addChild(coordinator)
        coordinator.start()
    }
    
    func presentClickToStartPage() {
        
        let coordinator = ClickToStartPageCoordinator(
            navigationController: navigationController
        )
        
        addChild(coordinator)
        coordinator.start()
    }
    
    func presentChoosePlatformPage() {
        
        let coordinator = ChoosePlatformPageCoordinator(
            navigationController: navigationController
        )
        
        addChild(coordinator)
        coordinator.start()
    }
}

extension DefaultRootCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
        switch childCoordinator {
        case is NetworkConfigSettingPageCoordinator:
            
            children.removeAll()
            navigationController.viewControllers.removeAll()
            
            start()
            
        default:
            return
        }
    }
}
