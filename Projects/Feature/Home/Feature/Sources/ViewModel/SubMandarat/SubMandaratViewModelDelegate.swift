//
//  SubMandaratViewModelDelegate.swift
//  Home
//
//  Created by choijunios on 12/15/24.
//

import DomainMandaratInterface

protocol SubMandaratViewModelDelegate: AnyObject {
    
    func subMandarat(edit position: MandaratPosition)
}
