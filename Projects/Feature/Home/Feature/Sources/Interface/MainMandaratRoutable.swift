//
//  MainMandaratRoutable.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

public protocol MainMandaratRoutable: AnyObject {
    
    var viewModel: MainMandaratPageViewModelable { get }
    var viewController: MainMandaratPageViewControllable { get }
}
