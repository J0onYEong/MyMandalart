//
//  SubMandaratDisplayView.swift
//  Home
//
//  Created by choijunios on 12/24/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class SubMandaratDisplayView: UIView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private let acheivementRate: AcheivementRateView = .init()
    
    
    // Reactive
    fileprivate let renderObject: PublishRelay<SubMandaratRO> = .init()
    private let disposeBag: DisposeBag = .init()
    
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }

    
    private func setUI() {
        
        self.layer.cornerRadius = SubMandaratConfig.cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.gray.cgColor
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    private func setLayout() {
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            titleLabel, acheivementRate
        ])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        
        acheivementRate.snp.makeConstraints { make in
            
            make.height.equalTo(20)
        }
        
        // MARK: titleLabel
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    
    private func setReactive() {
        
        // Bind, titleLabel
        renderObject
            .observe(on: MainScheduler.instance)
            .map(\.title)
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        // Bind, acheivementRate
        renderObject
            .observe(on: MainScheduler.instance)
            .map(\.percent)
            .bind(to: acheivementRate.rx.percent)
            .disposed(by: disposeBag)
        
        renderObject
            .observe(on: MainScheduler.instance)
            .map(\.primaryColor)
            .bind(to: acheivementRate.rx.color)
            .disposed(by: disposeBag)
        
        
        // Bind, self
        renderObject
            .observe(on: MainScheduler.instance)
            .map(\.primaryColor)
            .bind(to: self.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base == SubMandaratDisplayView {
    
    var renderObject: PublishRelay<SubMandaratRO> {
        
        base.renderObject
    }
}
