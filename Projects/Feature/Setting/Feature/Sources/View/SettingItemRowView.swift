//
//  SettingItemRowView.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import UIKit

import SharedDesignSystem

import RxSwift
import SnapKit

class SettingItemRowView: TappableView {
    
    // Sub view
    private let rowLabel: UILabel = .init()
    private let guideImage: UIImageView = .init(
        image: .init(systemName: "chevron.right")
    )
    
    
    private let disposeBag: DisposeBag = .init()
    
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    
    public func update(_ text: String, image: UIImage? = nil) {
        
        rowLabel.text = text
        
        if let image {
            guideImage.image = image
        }
    }
    
    
    private func setUI() {
        
        // self
        self.backgroundColor = .white
        
        // rowLabel
        rowLabel.textColor = .gray
        rowLabel.font = .preferredFont(forTextStyle: .body)
        rowLabel.adjustsFontSizeToFitWidth = true
        
        // guideImage
        guideImage.contentMode = .scaleAspectFit
        guideImage.tintColor = .gray
    }
    
    
    private func setLayout() {
        
        let stack: UIStackView = .init(arrangedSubviews: [rowLabel, UIView(), guideImage])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        
        addSubview(stack)
        
        stack.snp.makeConstraints { make in
            
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(10)
        }
    }
    
    
    private func setReactive() {
        
        tap
            .subscribe(onNext: { [weak self] in
            
                self?.backgroundColor = .lightGray.withAlphaComponent(0.5)
                
                UIView.animate {
                    self?.backgroundColor = .white
                }
            })
            .disposed(by: disposeBag)
    }
}


extension Reactive where Base == SettingItemRowView {
    
    var tap: Observable<Void> {
        base.tap
    }
}


#Preview {
    
    let view = SettingItemRowView()
    
    view.update("Hello world")
    
    return view
}
