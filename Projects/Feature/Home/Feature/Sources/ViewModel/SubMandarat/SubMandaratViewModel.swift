//
//  SubMandaratViewModel.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import DomainMandaratInterface

import ReactorKit
import RxSwift

class SubMandaratViewModel: Reactor {
    
    var initialState: State
    
    private let position: MandaratPosition
    
    init(position: MandaratPosition, color: UIColor) {
        
        self.position = position
        
        self.initialState = .init(
            titleColor: color
        )
    }
}

// MARK: Action & State
extension SubMandaratViewModel {
    
    enum Action {
        
    }
    
    struct State {
        
        var isAvailable: Bool = false
        var titleColor: UIColor
    }
}
