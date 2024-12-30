//
//  CancellableToastView.swift
//  SharedDesignSystem
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import RxSwift
import RxCocoa

public class CancellableToastView: UIView {
    
    // Sub view
    private let cancellButton: UIImageView = .init(
        image: .init(systemName: "xmark.circle")
    )
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    
    public init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    public required init?(coder: NSCoder) { nil }
    
    deinit {
        
        debugPrint("denit CancellableToastView")
    }
    
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
        
        
        // cancel button
        cancellButton.contentMode = .scaleAspectFit
        cancellButton.tintColor = .white
    }
    
    
    private func setLayout() {
        
        let labelStackView: UIStackView = .init(arrangedSubviews: [
            titleLabel, descriptionLabel
        ])
        labelStackView.axis = .vertical
        labelStackView.alignment = .fill
        
        
        let containerStackView: UIStackView = .init(arrangedSubviews: [
            labelStackView, cancellButton
        ])
        containerStackView.axis = .horizontal
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        
        addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints { make in
            
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    fileprivate var cancelButtonTapGesture: UIGestureRecognizer!
    
    private func setTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCancelButtonTapped(_:)))
        addGestureRecognizer(tapGesture)
        self.cancelButtonTapGesture = tapGesture
    }
    @objc
    private func onCancelButtonTapped(_ gesture: UIGestureRecognizer) {
        
        cancellButton.alpha = 0
        UIView.animate(withDuration: 0.35) {
            self.cancellButton.alpha = 1
        }
    }
}


public extension Reactive where Base == CancellableToastView {
    
    var cancelButtonTapped: Observable<Void> {
        base.cancelButtonTapGesture.rx.event
            .asObservable()
            .map({ _ in () })
    }
}


#Preview {
    
    let view = CancellableToastView()
    
    view.update(
        title: "이것은 테스트타이틀",
        description: "이것은 테스트 디스크립션"
    )
    
    return view
}
