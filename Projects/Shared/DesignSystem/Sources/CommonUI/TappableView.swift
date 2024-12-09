//
//  TappableView.swift
//  DesignSystem
//
//  Created by choijunios on 12/7/24.
//

import UIKit

import RxSwift

open class TappableView: UIView {
    
    public let tap: PublishSubject<Void> = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapRecognizer: UITapGestureRecognizer = .init()
        tapRecognizer.addTarget(self, action: #selector(onTap))
        addGestureRecognizer(tapRecognizer)
    }
    public required init?(coder: NSCoder) { nil }
    
    @objc
    private func onTap() {
        
        tap.onNext(())
    }
}
