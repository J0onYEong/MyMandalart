//
//  EditSubMandaratViewModelDelegate.swift
//  Home
//
//  Created by choijunios on 12/24/24.
//

import DomainMandaratInterface

protocol EditSubMandaratViewModelDelegate: AnyObject {
    
    func editFinishedWithSavingRequest(edited subMandarat: SubMandaratVO)
}
