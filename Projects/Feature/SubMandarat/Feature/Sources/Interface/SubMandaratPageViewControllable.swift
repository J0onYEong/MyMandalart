//
//  SubMandaratPageViewControllable.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import UIKit

public protocol SubMandaratPageViewControllable: UIViewController {
    
    var transitionDelegate: UINavigationControllerDelegate { get }
}
