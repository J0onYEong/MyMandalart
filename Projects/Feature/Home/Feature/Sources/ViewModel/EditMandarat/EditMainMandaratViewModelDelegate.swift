//
//  EditMainMandaratViewModelDelegate.swift
//  Home
//
//  Created by choijunios on 12/11/24.
//

import DomainMandaratInterface

protocol EditMainMandaratViewModelDelegate: AnyObject {
    
    func editFinishedWithSavingRequest(mainMandarat edited: MainMandaratVO)
}
