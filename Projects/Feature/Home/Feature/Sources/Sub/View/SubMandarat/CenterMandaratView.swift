//
//  CenterMandaratView.swift
//  Home
//
//  Created by choijunios on 12/26/24.
//

import UIKit

import DomainMandaratInterface
import SharedDesignSystem

import RxCocoa
import RxSwift
import SnapKit

class CenterMandaratView: TappableView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private var gradientLayer: CAGradientLayer = .init()
    
    
    // Reactive
    private let disposeBag: DisposeBag = .init()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
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


// MARK: Public interface
extension CenterMandaratView {
    
    public func render(_ mandaratVO: MainMandaratVO) {
        
        // title label
        titleLabel.text = mandaratVO.title
        
        // gradient
        createGredientLayer(.color(mandaratVO.hexColor) ?? .white)
        
        // play gradient variation
        playGradientAnimation()
    }
}


// MARK: Reactive+Ext
extension Reactive where Base == MainMandaratDisplayView {
    
}
