//
//  ImageButton.swift
//  DesignSystem
//
//  Created by choijunios on 12/10/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

public class ImageButton: TappableView {
    
    // Sub view
    private let imageView: UIImageView = .init()
    private let imageName: String
    private let backColor: UIColor = .gray.withAlphaComponent(0.1)
    private let imageColor: UIColor = .black
    
    private let disposeBag: DisposeBag = .init()
    
    public init(imageName: String) {
        self.imageName = imageName
        super.init(frame: .zero)
        
        setAppearance()
        setLayout()
        setReactive()
    }
    public required init?(coder: NSCoder) { nil }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = layer.bounds.width/2
    }
    
    private func setAppearance() {
        
        imageView.image = UIImage(systemName: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = imageColor
        
        self.backgroundColor = backColor
    }
    
    private func setLayout() {
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(10)
            make.bottom.greaterThanOrEqualToSuperview().inset(10)
            make.leading.greaterThanOrEqualToSuperview().inset(10)
            make.trailing.greaterThanOrEqualToSuperview().inset(10)
            
            make.center.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.width.equalTo(self.snp.height)
        }
    }
    
    private func setReactive() {
        
        self.tap
            .withUnretained(self)
            .subscribe(onNext: { view, _ in
                
                view.alpha = 0.5
                UIView.animate(withDuration: 0.2) {
                    view.alpha = 1
                }
            })
            .disposed(by: disposeBag)
    }
}

public extension Reactive where Base == ImageButton {
    
    var tap: Observable<Void> {
        
        base.tap
    }
}

#Preview(traits: .fixedLayout(width: 100.0, height: 100.0)) {
    
    ImageButton(imageName: "plus")
}
