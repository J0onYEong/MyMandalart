//
//  MainMandaratView.swift
//  Home
//
//  Created by choijunios on 12/7/24.
//

import UIKit

import SharedDesignSystem

import ReactorKit

final class MainMandaratView: UIView, View {
    
    // View
    
    
    
    // Reactor
    let reactor: MainMandaratViewModel
    var disposeBag: DisposeBag = .init()
    
    init(reactor: MainMandaratViewModel) {
        
        self.reactor = reactor
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { nil }
    
    
    func bind(reactor: MainMandaratViewModel) {
        
        
    }
    
    private func setLayer() {
        
        
    }
}
