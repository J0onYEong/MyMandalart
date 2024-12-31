//
//  NavigationBarView.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import UIKit

import SharedDesignSystem

import RxCocoa
import RxSwift

class NavigationBarView: UIView {
    
    // Sub view
    fileprivate let backButton: UIButton = .init()
    private let titleLabel: UILabel = .init()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    public func update(_ titleText: String) {
        
        titleLabel.text = titleText
    }
    
    
    private func setUI() {
        
        // self
        self.backgroundColor = .white
        
        
        // backButtonImage
        let backButtonImage = UIImage(systemName: "chevron.left")
        backButton.setImage(backButtonImage, for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.imageView?.tintColor = .black

        
        // titleLabel
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .black
    }
    
    
    private func setLayout() {
        
        let stack: UIStackView = .init(arrangedSubviews: [
            backButton, titleLabel, UIView()
        ])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .fill
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(backButton.snp.height)
        }
        
        let spacerView: UIView = .init()
        spacerView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        
        addSubview(stack)
        addSubview(spacerView)
        
        stack.snp.makeConstraints { make in
            
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalTo(spacerView.snp.top).inset(-10)
        }
        
        spacerView.snp.makeConstraints { make in
            
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}


extension Reactive where Base == NavigationBarView {
    
    var tap: ControlEvent<Void> {
        base.backButton.rx.tap
    }
}


#Preview {
    
    let view = NavigationBarView()
    view.update("설정")
    
    return view
}
