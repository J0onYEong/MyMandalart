//
//  SubMandaratDisplayView.swift
//  Home
//
//  Created by choijunios on 12/24/24.
//

import UIKit

import SharedPresentationExt
import SharedDesignSystem

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
    
    
    // Feed back for edit
    private let mainMandaratSelectionFeedback = UISelectionFeedbackGenerator()
    
    
    // Reactive
    private let disposeBag: DisposeBag = .init()
    
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setLongPressGesture()
    }
    required init?(coder: NSCoder) { nil }
    
    
    public func update(title: String, percent: Double, palette: MandalartPalette) {
        
        // self
        self.backgroundColor = palette.colors.backgroundColor.primaryColor
        
        
        // titleLabel
        titleLabel.text = title
        titleLabel.textColor = palette.colors.textColor.primaryColor

        
        // acheivementRate
        acheivementRate.rx.percent.accept(percent)
        acheivementRate.update(
            stickColor: palette.colors.gageColor.primaryColor,
            backgroundColor: palette.colors.gageColor.secondColor
        )
        
        
        // acheivementLabel
        acheivementLabel.textColor = palette.colors.textColor.secondColor
        let rounded = (percent * 100).rounded()
        acheivementLabel.text = "목표 달성율: \(rounded)%"
    
    }

    
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
    func onLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            
            mainMandaratSelectionFeedback
                .selectionChanged(at: gesture.location(in: self))
        }
    }
}


// MARK: Reactive+Ext
extension Reactive where Base == SubMandaratDisplayView {
    
    var longPressEvent: Observable<Void> {
        
        base.longPressGesture.rx.event.map({ _ in })
    }
}
