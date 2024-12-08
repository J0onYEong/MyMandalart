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
    private let addMandaratView: AddMandaratView = .init()
    private let reactor: MainMandaratViewModel
    
    var disposeBag: DisposeBag = .init()
    
    init(reactor: MainMandaratViewModel) {
        
        self.reactor = reactor
        
        super.init(frame: .zero)
        
        setLayer()
    }
    required init?(coder: NSCoder) { nil }
    
    func bind(reactor: MainMandaratViewModel) {
        
        // Presentation for add mandarat
        reactor.state
            .map(\.isAvailable)
            .bind(to: addMandaratView.present)
            .disposed(by: disposeBag)
    }
    
    private func setLayer() {
        
        addSubview(addMandaratView)
        
        addMandaratView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
}
