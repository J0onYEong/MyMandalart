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
    private let acheivementLabel: UILabel = .init()
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
        
        
        // titleLabel
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        
        
        // acheivementLabel
        acheivementLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        acheivementLabel.textAlignment = .center
        acheivementLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    private func setLayout() {
        
        let achievementStack: UIStackView = .init(arrangedSubviews: [
            acheivementRate, acheivementLabel
        ])
        achievementStack.axis = .vertical
        achievementStack.spacing = 2
        achievementStack.distribution = .fill
        achievementStack.alignment = .center
        
        acheivementRate.snp.makeConstraints { make in
            
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        acheivementLabel.snp.makeConstraints { make in
            
            make.width.equalTo(acheivementRate.snp.width).multipliedBy(0.75)
        }
        
        
        let mainStack: UIStackView = .init(arrangedSubviews: [
            titleLabel, achievementStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.distribution = .fill
        mainStack.alignment = .fill
        
        addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        
        achievementStack.snp.makeConstraints { make in
            
            make.width.equalToSuperview()
        }
    }
    
    
    private func setReactive() {
        
        // Bind, titleLabel
        renderObject
            .asDriver(onErrorDriveWith: .never())
            .map(\.title)
            .distinctUntilChanged()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        renderObject
            .asDriver(onErrorDriveWith: .never())
            .map(\.primaryColor)
            .distinctUntilChanged()
            .map({ $0.getInvertedColor() })
            .drive(titleLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        
        // Bind, acheivementRate
        renderObject
            .asDriver(onErrorDriveWith: .never())
            .map(\.percent)
            .distinctUntilChanged()
            .drive(acheivementRate.rx.percent)
            .disposed(by: disposeBag)
        
        renderObject
            .asDriver(onErrorDriveWith: .never())
            .map(\.primaryColor)
            .distinctUntilChanged()
            .drive(acheivementRate.rx.color)
            .disposed(by: disposeBag)
        
        
        // acheivementLabel
        renderObject
            .asDriver(onErrorDriveWith: .never())
            .map(\.primaryColor)
            .distinctUntilChanged()
            .map({ $0.getInvertedColor() })
            .drive(acheivementLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        renderObject
            .asDriver(onErrorDriveWith: .never())
            .map(\.percentText)
            .distinctUntilChanged()
            .drive(acheivementLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        // Bind, self
        renderObject
            .asDriver(onErrorDriveWith: .never())
            .map(\.primaryColor)
            .distinctUntilChanged()
            .drive(rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base == SubMandaratDisplayView {
    
    var renderObject: PublishRelay<SubMandaratRO> {
        
        base.renderObject
    }
}
