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
    private let tapView: TappableView = .init()
    private let addImageView: UIImageView = .init(image: .init(systemName: "plus.app.fill"))
    
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
        }
    }
    
    private func setReactive() {
        
        color
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { view, color in
                
                view.tapView.backgroundColor = color
                view.addImageView.tintColor = color.getTriadicColors().randomElement()
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base == AddSubMandaratView {
    
    var color: PublishSubject<UIColor> {
        
        base.color
    }
}
