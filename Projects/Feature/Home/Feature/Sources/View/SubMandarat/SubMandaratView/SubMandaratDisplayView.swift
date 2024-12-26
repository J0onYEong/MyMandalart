//
//  SubMandaratDisplayView.swift
//  Home
//
//  Created by choijunios on 12/24/24.
//

import UIKit

import SharedPresentationExt

import RxCocoa
import RxSwift
import SnapKit

class SubMandaratDisplayView: UIView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private let acheivementLabel: UILabel = .init()
    private let acheivementRate: AcheivementRateView = .init()
    
    
    // Gesture
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    
    // Reactive
    fileprivate let renderObject: PublishRelay<SubMandaratRO> = .init()
    private let disposeBag: DisposeBag = .init()
    
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setReactive()
        setLongPressGesture()
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
            .distinctDriver(\.title, titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        renderObject
            .distinctDriver(\.primaryColor)
            .map({ $0.getInvertedColor() })
            .drive(titleLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        
        // Bind, acheivementRate
        renderObject
            .distinctDriver(\.percent)
            .drive(acheivementRate.rx.percent)
            .disposed(by: disposeBag)
        
        renderObject
            .distinctDriver(\.primaryColor)
            .drive(acheivementRate.rx.color)
            .disposed(by: disposeBag)
        
        
        // acheivementLabel
        renderObject
            .distinctDriver(\.primaryColor)
            .map({ $0.getInvertedColor() })
            .drive(acheivementLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        renderObject
            .distinctDriver(\.percentText, acheivementLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        // Bind, self
        renderObject
            .distinctDriver(\.primaryColor, rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}


// MARK: Press action
private extension SubMandaratDisplayView {
    
    func setLongPressGesture() {
        
        if longPressGesture != nil { return }
        
        let gesture: UILongPressGestureRecognizer = .init(target: self, action: #selector(onLongPress(_:)))
        gesture.minimumPressDuration = 0.75
        self.addGestureRecognizer(gesture)
        
        self.longPressGesture = gesture
    }
    
    @objc
    func onLongPress(_ gesture: UILongPressGestureRecognizer) { }
}


// MARK: Reactive+Ext
extension Reactive where Base == SubMandaratDisplayView {
    
    var renderObject: PublishRelay<SubMandaratRO> {
        
        base.renderObject
    }
    
    var longPressEvent: Observable<Void> {
        
        base.longPressGesture.rx.event.map({ _ in })
    }
}
