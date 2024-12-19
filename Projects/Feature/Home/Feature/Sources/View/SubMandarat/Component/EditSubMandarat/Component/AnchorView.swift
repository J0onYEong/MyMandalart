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
        let view: UIImageView = .init(image: .init(systemName: "checkmark.circle.fill"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let panGesture: UIPanGestureRecognizer = .init()
    fileprivate let panGestureMovingDistanceEvent: PublishSubject<(CGFloat, UIGestureRecognizer.State)> = .init()
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
        
        self.layer.cornerRadius = layer.bounds.width/2
    }
    
    
    private func setUI() {
        
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
    }
    
    
    private func setGesture() {
        
        self.addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(gestureCallback(panGesture:)))
    }
    @objc
    private func gestureCallback(panGesture: UIPanGestureRecognizer) {
        let moveDistance = panGesture.translation(in: self).x
        panGestureMovingDistanceEvent.onNext((moveDistance, panGesture.state))
    }
    
    
    private func setLayout() {
        
        addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base == AnchorView {
    
    var move: Observable<(CGFloat, UIGestureRecognizer.State)> {
        
        base.panGestureMovingDistanceEvent.asObservable()
    }
    
    var poinColor: Binder<UIColor?> {
        
        base.iconView.rx.tintColor
    }
}
