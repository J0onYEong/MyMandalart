//
//  MainMandaratViewModelDelegate.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import DomainMandaratInterface

protocol MainMandaratViewModelDelegate: AnyObject {
    
    func mainMandarat(buttonClicked position: MandaratPosition)
}
