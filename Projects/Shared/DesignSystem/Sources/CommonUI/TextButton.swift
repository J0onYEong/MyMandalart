//
//  TextButton.swift
//  DesignSystem
//
//  Created by choijunios on 12/10/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

public class TextButton: TappableView {
    
    // Sub view
    private let labelView: UILabel = .init()
    private let text: String
    private let backColor: UIColor = .gray.withAlphaComponent(0.1)
    private let textColor: UIColor = .black
    
    private let disposeBag: DisposeBag = .init()
    
    public init(text: String) {
        self.text = text
        super.init(frame: .zero)
        
        setAppearance()
        setLayout()
        setReactive()
    }
    public required init?(coder: NSCoder) { nil }
    
    
    // for test
    func invokeTap() {
        
        self.tap.onNext(())
    }
    
    
    private func setAppearance() {
        
        labelView.text = text
        labelView.font = .preferredFont(forTextStyle: .body)
        labelView.textColor = textColor
        
        self.layer.cornerRadius = 15
        self.backgroundColor = backColor
    }
    
    private func setLayout() {
        
        addSubview(labelView)
        
        labelView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    private func setReactive() {
        
        self.tap
            .withUnretained(self)
            .subscribe(onNext: { view, _ in
                
                view.alpha = 0.5
                UIView.animate(withDuration: 0.2) {
                    view.alpha = 1
                }
            })
            .disposed(by: disposeBag)
    }
}

public extension Reactive where Base == TextButton {
    
    var tap: Observable<Void> {
        
        base.tap
    }
}

#Preview {
    
    TextButton(text: "안녕")
}
