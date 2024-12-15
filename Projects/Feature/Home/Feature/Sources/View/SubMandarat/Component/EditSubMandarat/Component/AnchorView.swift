//
//  AnchorView.swift
//  Home
//
//  Created by choijunios on 12/15/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class AnchorView: UIView {
    
    // Sub view
    fileprivate let iconView: UIImageView = {
        let view: UIImageView = .init(image: .init(systemName: "star.fill"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    fileprivate let panGesture: UIPanGestureRecognizer = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setGesture()
        setLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.layer.cornerRadius = iconView.layer.bounds.width/2
    }
    
    
    private func setUI() {
        
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
    }
    
    
    private func setGesture() {
        
        self.addGestureRecognizer(panGesture)
    }
    
    
    private func setLayout() {
        
        addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}

extension Reactive where Base == AnchorView {
    
    var dragGesture: ControlEvent<UIPanGestureRecognizer> {
        
        base.panGesture.rx.event
    }
    
    var poinColor: Binder<UIColor?> {
        
        base.iconView.rx.tintColor
    }
}
