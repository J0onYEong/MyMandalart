//
//  SettingPageViewController.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

class SettingPageViewController: UIViewController, View, SettingPageViewControllable {
    
    // Sub view
    
    
    var disposeBag: DisposeBag = .init()
 
    init(reactor: SettingPageViewModel) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    required init?(coder: NSCoder) { nil }
    
    
    func bind(reactor: SettingPageViewModel) {
        
    }
}

