//
//  SubMandaratPageRoutable.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import UIKit

public protocol SubMandaratPageRoutable {
    var viewModel: SubMandaratPageViewModelable { get }
    var viewController: SubMandaratPageViewControllable { get }
    var transitionDelegate: UINavigationControllerDelegate { get }
}
