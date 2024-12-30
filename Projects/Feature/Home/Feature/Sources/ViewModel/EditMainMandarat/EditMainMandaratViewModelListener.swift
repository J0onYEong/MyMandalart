//
//  EditMainMandaratViewModelListener.swift
//  Home
//
//  Created by choijunios on 12/11/24.
//

import DomainMandaratInterface

protocol EditMainMandaratViewModelListener: AnyObject {
    
    func editFinished()
    
    func editFinishedWithSavingRequest(edited mainMandarat: MainMandaratVO)
}
