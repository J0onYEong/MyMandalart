//
//  PaletteCellView.swift
//  Home
//
//  Created by choijunios on 1/1/25.
//

import UIKit

import SharedDesignSystem

import SnapKit
import RxSwift

class PaletteCellView: TappableView {
    
    // Sub view
    private var colorView: UIView!
    
    
    private let colors: [UIColor]
    
    private let disposeBag: DisposeBag = .init()
    
    init(color1: UIColor, color2: UIColor, color3: UIColor) {
        self.colors = [
            color1,
            color2,
            color3,
        ]
        
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.bounds.height / 4
    }
    
    
    public func update(isFocused: Bool) {
        
        if isFocused {
            
            colorView.alpha = 1
            layer.borderWidth = 1
            
        } else {
            
            colorView.alpha = 0.75
            layer.borderWidth = 0
        }
    }
    
    
    private func setUI() {
        
        self.backgroundColor = .white
        
        clipsToBounds = true
        
        layer.borderColor = UIColor.gray.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .init(width: 0, height: -2)
    }
    
    
    private func setLayout() {
        
        let subViews = colors.map { color in
            let view = UIView()
            view.backgroundColor = color
            return view
        }
        
        let stack: UIStackView = .init(arrangedSubviews: subViews)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 0
        
        addSubview(stack)
        
        stack.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
            make.width.equalTo(stack.snp.height)
        }
        
        self.colorView = stack
    }
    
    
    private func setReactive() {
        
        self.tap
            .subscribe(onNext: { [weak self] in
                
                self?.alpha = 0.5
                UIView.animate(withDuration: 0.35) {
                    self?.alpha = 1
                }
            })
            .disposed(by: disposeBag)
    }
}


#Preview {
    
    PaletteCellView(
        color1: .blue,
        color2: .red,
        color3: .yellow
    )
}
