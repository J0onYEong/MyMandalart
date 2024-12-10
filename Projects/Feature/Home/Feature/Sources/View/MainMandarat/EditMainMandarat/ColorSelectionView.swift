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
        
        setLabel()
        setColorView()
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isLayerAdded {
            isLayerAdded = true
            
            addBorderToColorView()
        }
    }
    
    private func setReactive() {
        
        selectedColor
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { color in
                        
            })
            .disposed(by: disposeBag)
    }
    
    private func setLabel() {
        
        titleLabel.textColor = .black
        titleLabel.text = labelText
    }
    
    private func setColorView() {
        
        colorView.layer.cornerRadius = 5
    }
    
    private func setLayout() {
        
        let stackView: UIStackView = .init(arrangedSubviews: [titleLabel, colorView])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        
        colorView.snp.makeConstraints { make in
            make.width.equalTo(65)
            make.height.equalTo(30)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
    
    private func addBorderToColorView() {
        
        let borderLayer: CALayer = .init(layer: colorView.layer)
        
        borderLayer.backgroundColor = UIColor.white.cgColor
        borderLayer.borderWidth = 2
        borderLayer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        let maskLayer: CALayer = .init(layer: borderLayer)
        maskLayer.backgroundColor = UIColor.clear.cgColor
        
        borderLayer.mask = maskLayer
        
        colorView.layer.addSublayer(borderLayer)
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
