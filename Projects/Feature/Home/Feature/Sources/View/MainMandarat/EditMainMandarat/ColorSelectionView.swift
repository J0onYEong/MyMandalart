//
//  ColorSelectionView.swift
//  Home
//
//  Created by choijunios on 12/10/24.
//

import UIKit

import SharedDesignSystem

import RxCocoa
import RxSwift

class ColorSelectionView: UIView {
    
    private let labelText: String
    private var isLayerAdded: Bool = false
    
    // Sub view
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    fileprivate let colorView: TappableView = .init()
    
    // Observable
    fileprivate let selectedColor: BehaviorSubject<UIColor> = .init(value: .white)
    private let disposeBag: DisposeBag = .init()
    
    init(labelText: String) {
        
        self.labelText = labelText
        
        super.init(frame: .zero)
        
        setAppearance()
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setReactive() {
        
        selectedColor
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { color in
                        
            })
            .disposed(by: disposeBag)
    }
    
    private func setAppearance() {
        
        titleLabel.textColor = .black
        titleLabel.text = labelText
        
        colorView.layer.cornerRadius = 5
        colorView.backgroundColor = .white
        colorView.layer.borderColor = UIColor.gray.cgColor
        colorView.layer.borderWidth = 2
        
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        self.layer.cornerRadius = 15
    }
    
    private func setLayout() {
        
        let stackView: UIStackView = .init(arrangedSubviews: [titleLabel, colorView])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        colorView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }
}

extension Reactive where Base == ColorSelectionView {
    
    var color: BehaviorSubject<UIColor> {
        
        self.base.selectedColor
    }
    
    var colorSelectionTap: Observable<Void> {
        
        self.base.colorView.tap
    }
}

#Preview {
    
    ColorSelectionView(labelText: "대표 색상")
}
