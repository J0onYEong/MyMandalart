//
//  EditMainMandaratView.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import ReactorKit

// id, imageURL, title, story, hexColor

class EditMainMandaratView: UIView, View {
    
    // Sub View
    private let titleTextField: UITextField = {
        let textField: UITextField = .init()
        return textField
    }()
    
    
    
    
    let reactor: EditMainMandaratViewModel
    var disposeBag: DisposeBag = .init()
    
    init(reactor: EditMainMandaratViewModel) {
        
        self.reactor = reactor
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { nil }
    
    func bind(reactor: EditMainMandaratViewModel) {
        
        
    }
}
