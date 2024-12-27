//
//  SubMandaratViewModelListener.swift
//  Home
//
//  Created by choijunios on 12/15/24.
//

import DomainMandaratInterface

protocol SubMandaratViewModelListener: AnyObject {
    
    func subMandarat(edit position: MandaratPosition)
}
