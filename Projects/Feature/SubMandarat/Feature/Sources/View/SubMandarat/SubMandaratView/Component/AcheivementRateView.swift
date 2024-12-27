//
//  AcheivemnetRateView.swift
//  Home
//
//  Created by choijunios on 12/24/24.
//

import UIKit

import SharedCore

import RxSwift
import RxCocoa
import SnapKit

class AcheivementRateView: UIView {
    
    // Sub view
    private let rateStick: UIView = .init()
    
    
    // Reactive
    fileprivate let percentPublisher: BehaviorRelay<CGFloat> = .init(value: 0.0)
    fileprivate let colorPublisher: BehaviorRelay<UIColor> = .init(value: .clear)
    private let disposBag: DisposeBag = .init()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setReative()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let percent = percentPublisher.value
        
        let widthOfView = layer.bounds.width
        let heightOfView = layer.bounds.height
        let padding: CGFloat = 3
        
        let stickOrigin: CGPoint = .init(x: padding, y: padding)
        let stickSize: CGSize = .init(
            width: (widthOfView-2*padding) * percent,
            height: heightOfView-2*padding
        )
        
        self.rateStick.frame = .init(origin: stickOrigin, size: .init(width: 0, height: stickSize.height))
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut) {
                
            self.rateStick.frame = .init(origin: stickOrigin, size: stickSize)
        }
        
        rateStick.layer.cornerRadius = rateStick.layer.bounds.height / 3
        self.layer.cornerRadius = self.layer.bounds.height / 3
    }
    
    private func setUI() {
        
    }
    
    
    private func setLayout() {
        
        // rateStick
        addSubview(rateStick)
    }
    
    
    private func setReative() {
        
        // percent
        percentPublisher
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { view, _ in
                view.setNeedsLayout()
            })
            .disposed(by: disposBag)
        
        
        colorPublisher
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { view, color in
                
                let mainColor = color
                let flipColor = color.getInvertedColor()
                
                // #1. background
                view.backgroundColor = flipColor
                
                // #2. stick color
                view.rateStick.backgroundColor = mainColor
                
            })
            .disposed(by: disposBag)
    }
}

extension Reactive where Base == AcheivementRateView {
    
    var color: BehaviorRelay<UIColor> {
        base.colorPublisher
    }
    
    var percent: BehaviorRelay<CGFloat> {
        base.percentPublisher
    }
}

#Preview(traits: .fixedLayout(width: 30, height: 10), body: {
    
    AcheivementRateView()
})