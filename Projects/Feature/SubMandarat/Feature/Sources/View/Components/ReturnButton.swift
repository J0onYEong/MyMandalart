//
//  ReturnButton.swift
//  SubMandarat
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import SharedDesignSystem

import SnapKit
import RxSwift

class ReturnButton: TappableView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private let imageView: UIImageView = .init(
        image: .init(systemName: "arrow.clockwise")
    )
    
    
    private let disposeBag: DisposeBag = .init()
    
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setReactive()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setUI() {
        
        titleLabel.text = "돌아기기"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .gray
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
    }
    
    
    private func setLayout() {
        
        let stackView: UIStackView = .init(
            arrangedSubviews: [imageView, titleLabel]
        )
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill

        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    private func setReactive() {
        
        self.tap
            .subscribe(onNext: { [weak self] in
                
                guard let self else { return }
                
                self.alpha = 0.5
                UIView.animate(withDuration: 0.35) {
                    self.alpha = 1
                }
            })
            .disposed(by: disposeBag)
    }
 }
