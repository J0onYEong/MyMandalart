//
//  ToastView.swift
//  SharedDesignSystem
//
//  Created by choijunios on 12/28/24.
//

import UIKit

import SharedPresentationExt
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
    
    
    public func update(title: String, description: String?, backgroundColor: UIColor? = nil) {
        
        // text
        titleLabel.text = title
        
        if let description, !description.isEmpty {
            
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
            
        } else {
            
            descriptionLabel.isHidden = true
        }
        
        
        // backgroundColor
        if let backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }
    
    
    private func setUI() {
        
        // self
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 5
        
        
        // titleLabel
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
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
