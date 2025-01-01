//
//  PaletteCellView.swift
//  Home
//
//  Created by choijunios on 1/1/25.
//

import UIKit

import SharedDesignSystem

import SnapKit

class PaletteCellView: TappableView {
    
    private let colors: [UIColor]
    
    init(color1: UIColor, color2: UIColor, color3: UIColor) {
        self.colors = [
            color1,
            color2,
            color3,
        ]
        
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.bounds.height / 4
    }
    
    
    private func setUI() {
        
        clipsToBounds = true
        layer.borderWidth = 1
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
    }
}


#Preview {
    
    PaletteCellView(
        color1: .blue,
        color2: .red,
        color3: .yellow
    )
}
