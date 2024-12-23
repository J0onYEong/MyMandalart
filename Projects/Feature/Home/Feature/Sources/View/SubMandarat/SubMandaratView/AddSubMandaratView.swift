//
//  AddSubMandaratView.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import SharedDesignSystem

import RxSwift
import RxCocoa
import SnapKit

class AddSubMandaratView: UIView {
    
    // Sub view
    fileprivate let tapView: TappableView = .init()
    private let addImageView: UIImageView = {
        let view: UIImageView = .init(image: .init(systemName: "plus.circle.fill"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    fileprivate let color: PublishSubject<UIColor> = .init()
    private let disposeBag: DisposeBag = .init()
    
    init() {
        super.init(frame: .zero)
        
        setLayer()
        setLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setLayer() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = SubMandaratConfig.corenrRadius
        
        tapView.layer.cornerRadius = SubMandaratConfig.corenrRadius
        tapView.layer.borderColor = UIColor.gray.cgColor
        tapView.layer.borderWidth = 2
    }
    
    private func setLayout() {
        
        addSubview(tapView)
        tapView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        addSubview(addImageView)
        addImageView.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
            
            make.width.equalTo(32)
            make.height.equalTo(addImageView.snp.width)
        }
    }
    
    private func setReactive() {
        
        color
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { view, color in
                
                view.tapView.backgroundColor = color
                view.addImageView.tintColor = color.getInvertedColor()

            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base == AddSubMandaratView {
    
    var color: PublishSubject<UIColor> {
        
        base.color
    }
    
    var tap: PublishSubject<Void> {
        
        base.tapView.tap
    }
}
