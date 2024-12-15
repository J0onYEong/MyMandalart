//
//  AdjustAcheivementLevelView.swift
//  Home
//
//  Created by choijunios on 12/15/24.
//

import UIKit
import SwiftUI

import SharedDesignSystem

import RxSwift
import SnapKit

class AdjustAcheivementLevelView: UIView {
    
    // Sub view
    private let anchorView: AnchorView = .init()
    private let progressAreaView: UIView = .init()
    
    
    // Drag gesture
    fileprivate var dragMaxDistance: CGFloat?
    private var leftAnchorForAnchorView: Constraint!
    private var previousLeftAnchorInset: CGFloat = 0
    private var currentLeftAnchorInset: CGFloat = 0
 
    
    // Reactor
    private let disposeBag: DisposeBag = .init()
    
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
        setReative()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dragMaxDistance = progressAreaView.bounds.width - anchorView.bounds.width
    }
    
    
    private func setLayout() {
        
        // MARK: anchorView
        progressAreaView.addSubview(anchorView)
        
        anchorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            
            self.leftAnchorForAnchorView = make.left.equalToSuperview().constraint
            self.leftAnchorForAnchorView?.isActive = true
        }
        
        // MARK: Cotainer
        let stackView: UIStackView = .init(
            arrangedSubviews: [progressAreaView]
        )
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    private func setReative() {
        
        anchorView.rx.move
            .subscribe(onNext: { [weak self] distance, state in
                
                guard let self else { return }
                
                updateAnchor(state, distance)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: Drag action
extension AdjustAcheivementLevelView {
    
    func updateAnchor(_ state: UIGestureRecognizer.State, _ distance: CGFloat) {
        
        guard let dragMaxDistance else { return }
        
        switch state {
        case .began, .changed:
            var nextLeftAnchorInset = previousLeftAnchorInset + distance
            nextLeftAnchorInset = max(nextLeftAnchorInset, 0)
            nextLeftAnchorInset = min(nextLeftAnchorInset, dragMaxDistance)
            
            leftAnchorForAnchorView.update(inset: nextLeftAnchorInset)
            self.currentLeftAnchorInset = nextLeftAnchorInset
            
        case .ended:
            self.previousLeftAnchorInset = currentLeftAnchorInset
        default:
            break
        }
    }
}
