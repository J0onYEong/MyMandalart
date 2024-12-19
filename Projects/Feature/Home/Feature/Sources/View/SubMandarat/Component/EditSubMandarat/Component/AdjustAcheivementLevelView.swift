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
    
    // - Auto drag
    private let dragPoints: [DragPoint] = [
        .init(targetPrecent: 0.0),
        .init(targetPrecent: 0.25),
        .init(targetPrecent: 0.5),
        .init(targetPrecent: 0.75),
        .init(targetPrecent: 1.00),
    ]
    
 
    
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
        
        
        // MARK: Anchor background
        
        
        
        
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
private extension AdjustAcheivementLevelView {
    
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
            
            if let adjustedInset = checkAdjacentToDragPoint() {
                
                UIView.animate(withDuration: 0.1) {
                    
                    self.anchorView.isUserInteractionEnabled = false
                    self.leftAnchorForAnchorView.update(inset: adjustedInset)
                    self.layoutIfNeeded()
                    
                } completion: { _ in
                    self.anchorView.isUserInteractionEnabled = true
                }
                
                self.currentLeftAnchorInset = adjustedInset
            }
            
            self.previousLeftAnchorInset = currentLeftAnchorInset
            
        default:
            break
        }
    }
    
    
    func checkAdjacentToDragPoint() -> CGFloat? {
        
        guard let dragMaxDistance else { return nil }
        
        let moveDistance = anchorView.frame.origin.x
        let movePercent: CGFloat = moveDistance / dragMaxDistance
        
        for point in dragPoints {
            
            if point.checkInclude(percent: movePercent) {
                
                // 특정 구간에 포함되는 경우
                
                return dragMaxDistance * point.targetPrecent
            }
        }
                
        return nil
    }
}


// MARK: Native type
extension AdjustAcheivementLevelView {
    
    struct DragPoint {
        
        let targetPrecent: CGFloat
        
        init!(targetPrecent: CGFloat) {
            
            if (0.0...1.0).contains(targetPrecent) {
                
                self.targetPrecent = targetPrecent
                
            } else {
                
                return nil
            }
        }
        
        private let insetForRange: CGFloat = 0.1
        
        private var leftBound: CGFloat {
            max(0, targetPrecent - insetForRange)
        }
        
        private var rightBound: CGFloat {
            min(100, targetPrecent + insetForRange)
        }
        
        // public
        func checkInclude(percent check: CGFloat) -> Bool {
            
            (leftBound...rightBound).contains(check)
        }
    }
}
