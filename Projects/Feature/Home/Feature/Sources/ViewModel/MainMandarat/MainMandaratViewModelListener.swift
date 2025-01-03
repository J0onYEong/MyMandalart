//
//  MainMandaratViewModelDelegate.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import DomainMandaratInterface

protocol MainMandaratViewModelListener: AnyObject {
    
    func mainMandarat(editButtonClicked position: MandaratPosition)
    
    func mainMandarat(detailButtonClicked position: MandaratPosition)
}

extension MainMandaratViewModelListener {
    
    func mainMandarat(editButtonClicked position: MandaratPosition) { }
    func mainMandarat(detailButtonClicked position: MandaratPosition) { }
}
