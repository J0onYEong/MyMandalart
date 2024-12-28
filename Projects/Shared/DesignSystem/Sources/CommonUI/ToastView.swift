//
//  ToastView.swift
//  SharedDesignSystem
//
//  Created by choijunios on 12/28/24.
//

import UIKit

import SnapKit

public class ToastView: UIView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    
    public init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    public required init?(coder: NSCoder) { nil }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    public func update(title: String, description: String?) {
        
        titleLabel.text = title
        
        if let description, !description.isEmpty {
            
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
            
        } else {
            
            descriptionLabel.isHidden = true
        }
    }
    
    
    private func setUI() {
        
        // self
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 5
        
        
        // titleLabel
        titleLabel.textAlignment = .left
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        
        
        // descriptionLabel
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .preferredFont(forTextStyle: .caption2)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
    }
    
    
    private func setLayout() {
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            titleLabel, descriptionLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
}

#Preview {
    
    let view = ToastView()
    
    view.update(
        title: "이것은 타이틀입니다.",
        description: "이것은 디스크립션"
    )
    
    return view
}

#Preview {
    
    let view = ToastView()
    
    view.update(
        title: "이것은 타이틀입니다.",
        description: nil
    )
    
    return view
}
