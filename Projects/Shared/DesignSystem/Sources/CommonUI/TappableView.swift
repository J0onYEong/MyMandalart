//
//  TappableView.swift
//  DesignSystem
//
//  Created by choijunios on 12/7/24.
//

import UIKit

import RxSwift

open class TappableView: UIView {
    
    private let tapRecognizer: UITapGestureRecognizer = .init()
    
    public let tap: PublishSubject<Void> = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        tapRecognizer.addTarget(self, action: #selector(onTap))
    }
    public required init?(coder: NSCoder) { nil }
    
    @objc
    private func onTap() {
        
        tap.onNext(())
    }
}
