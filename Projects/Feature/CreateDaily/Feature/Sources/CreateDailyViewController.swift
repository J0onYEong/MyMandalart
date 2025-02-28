//
//  CreateDailyViewController.swift
//  CreateDaily
//
//  Created by choijunios on 2/28/25.
//

import UIKit

import ReactorKit

class CreateDailyViewController: UIViewController, View, CreateDailyViewControllable {
    
    var disposeBag: DisposeBag = .init()
    
    init(reactor: CreateDailyViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    required init?(coder: NSCoder) { nil }
    
    func bind(reactor: CreateDailyViewModel) {
        
    }
}
