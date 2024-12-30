//
//  ConfirmButton.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import SharedDesignSystem
import SharedPresentationExt

import RxSwift
import RxCocoa

class ConfirmButton: TappableView {
    
    // Sub view
    private let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    
    // State
    fileprivate let isEnabled: BehaviorRelay<Bool> = .init(value: false)
    
    
    private let disposeBag: DisposeBag = .init()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    public func setTitle(_ text: String) {
        
        titleLabel.text = text
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let heigt = layer.bounds.height
        
        layer.cornerRadius = heigt / 3
    }
    
    
    private func setLayout() {
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    
    private func setReactive() {
        
        isEnabled
            .asDriver()
            .drive(onNext: { [weak self] isEnabled in
                
                guard let self else { return }
                
                UIView.animate(withDuration: 0.35) {
                    
                    if isEnabled {
                        
                        self.setToEnabledAppearance()
                    } else {
                        
                        self.setToDisabledAppearance()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func setToEnabledAppearance() {
        
        backgroundColor = .color("#FFE6A9")
        titleLabel.textColor = .darkGray
    }
    
    private func setToDisabledAppearance() {
        
        backgroundColor = .lightGray
        titleLabel.textColor = .white
    }
}


extension Reactive where Base == ConfirmButton {
    
    var isEnabled: BehaviorRelay<Bool> {
        base.isEnabled
    }
    
    var tap: Observable<Void> {
        base.tap
    }
}


#Preview {
    
    let view = ConfirmButton()
    view.setTitle("테스트 타이틀")
    view.rx.isEnabled.accept(true)
    
    return view
}
