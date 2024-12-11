//
//  MainMandaratDisplayView.swift
//  Home
//
//  Created by choijunios on 12/11/24.
//

import UIKit

import SharedDesignSystem

import RxSwift
import RxCocoa

class MainMandaratDisplayView: TappableView {
    
    private let titleLabel: UILabel = .init()
    
    private var gradientLayer: CAGradientLayer = .init()
    
    fileprivate let renderObject: PublishSubject<MainMandaratRO> = .init()
    private let disposeBag: DisposeBag = .init()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    public func bind(_ mandaratRO: MainMandaratRO) {
        
        // text
        titleLabel.text = mandaratRO.title
        
        // gradient
        createGredientLayer(mandaratRO.titleColor)
    }
    
    private func setUI() {
        
        // self
        self.layer.cornerRadius = MainMandaratUIConfig.cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.gray.cgColor
        
        // title label
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    private func setLayout() {
        
        // MARK: titleLabel
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setReactive() {
        
        renderObject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { view, renderObject in
                
                // title label
                view.titleLabel.text = renderObject.title
                
                // gradient
                view.createGredientLayer(renderObject.titleColor)
                
                // play gradient variation
                view.playGradientAnimation()
            })
            .disposed(by: disposeBag)
    }
    
    private func createGredientLayer(_ baseColor: UIColor) {
        
        let subColor: UIColor = baseColor.withAlphaComponent(0.5)
        
        self.gradientLayer = .init(layer: self.layer)
        gradientLayer.frame = layer.bounds
        gradientLayer.type = .radial
        gradientLayer.colors = [subColor.cgColor, baseColor.cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 1, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func playGradientAnimation() {
        
        gradientLayer.removeAllAnimations()
        
        let animation: CABasicAnimation = .init(keyPath: "locations")
        animation.fromValue = [0,1]
        animation.toValue = [0,0.5]
        animation.duration = 3
        animation.repeatCount = .greatestFiniteMagnitude
        animation.autoreverses = true
        
        gradientLayer.add(animation, forKey: "gradientAnimation")
    }
}


extension Reactive where Base == MainMandaratDisplayView {
    
    var renderObject: PublishSubject<MainMandaratRO> {
        
        base.renderObject
    }
}
