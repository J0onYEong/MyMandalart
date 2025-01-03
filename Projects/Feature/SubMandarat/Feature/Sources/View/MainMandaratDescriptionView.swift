//
//  MainMandaratDescriptionView.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import UIKit

class MainMandaratDescriptionView: UIStackView {
    
    // Sub view
    let titleLabel: UILabel = .init()
    let descriptionLabel: UILabel = .init()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    required init(coder: NSCoder) { fatalError() }
    
    
    public func updateTitle(text: String) {
        
        self.titleLabel.text = text
        self.titleLabel.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.alpha = 1
        }
    }
    
    public func updateDescription(text: String) {
        
        self.descriptionLabel.text = text
        self.descriptionLabel.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
         
            self.descriptionLabel.alpha = 1
        }
    }
    
    
    private func setUI() {
        
        // titleLabel
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        // descriptionLabel
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
    }
    
    
    private func setLayout() {
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(descriptionLabel)
        
        self.axis = .vertical
        self.alignment = .fill
    }
}

#Preview {
    
    let view = MainMandaratDescriptionView()

    view.updateTitle(text: "이것은 타이틀")
    view.updateDescription(text: "이것은 디스크립션입니다. 이것은 디스크립션입니다. 이것은 디스크립션입니다. 이것은 디스크립션입니다. 이것은 디스크립션입니다.")
    
    return view
}
