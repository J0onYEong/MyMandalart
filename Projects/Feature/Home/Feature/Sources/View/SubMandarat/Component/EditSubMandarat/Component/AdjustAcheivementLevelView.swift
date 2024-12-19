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
    private let progressAreaView: UIView = .init()
    private let anchorView: AnchorView = .init()
    private let anchorPrecentView: UIView = .init()
    
    private let percentLabelContainer: UIView = .init()
    private var precentLabelViews: [DragPoint: UIView] = [:]
    
    
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
        
        createPrecentLabelViews()
        
        setUI()
        setLayout()
        setReative()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewWidth = progressAreaView.bounds.width
        
        dragMaxDistance = viewWidth - anchorView.bounds.width
        
        
        // Set anchorPrecentView corner radius
        anchorPrecentView.layer.cornerRadius = anchorPrecentView.layer.bounds.height/2
        
        
        // Set label views
        precentLabelViews.forEach { point, view in
            
            view.snp.updateConstraints { make in
                
                let anchorHalfWidth = anchorView.bounds.width/2
                let percentAmount = dragMaxDistance! * point.targetPrecent
                
                make.centerX.equalTo(percentLabelContainer.snp.left)
                    .inset(anchorHalfWidth + percentAmount)
            }
        }
    }
    
    
    private func setUI() {
        
        // anchorPrecentView
        anchorPrecentView.backgroundColor = .lightGray
        anchorPrecentView.layer.borderColor = UIColor.black.cgColor
        anchorPrecentView.layer.borderWidth = 1
    }
    
    
    private func setLayout() {
        
        // MARK: Anchor background
        progressAreaView.addSubview(anchorPrecentView)
        
        anchorPrecentView.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        
        // MARK: anchorView
        progressAreaView.addSubview(anchorView)
        
        anchorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(anchorView.snp.height)
            
            self.leftAnchorForAnchorView = make.left.equalToSuperview().constraint
            self.leftAnchorForAnchorView?.isActive = true
        }
        
        
        // MARK: percent label view
        precentLabelViews.forEach { dragPoint, view in
            
            percentLabelContainer.addSubview(view)
            
            view.snp.makeConstraints { make in
                
                make.top.greaterThanOrEqualToSuperview()
                make.bottom.lessThanOrEqualToSuperview()
                make.centerX.equalTo(percentLabelContainer.snp.left)
            }
        }
        
        
        // MARK: Cotainer
        let stackView: UIStackView = .init(
            arrangedSubviews: [percentLabelContainer, progressAreaView]
        )
        stackView.axis = .vertical
        stackView.spacing = 5
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


// MARK: Percent label view
private extension AdjustAcheivementLevelView {
    
    func createPrecentLabelViews() {
        
        dragPoints.forEach { point in
            
            let labelView = UILabel()
            labelView.text = "\(point.targetPrecent)%"
            labelView.font = .preferredFont(forTextStyle: .caption2)
            labelView.textColor = .gray
            
            self.precentLabelViews[point] = labelView
        }
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
    
    struct DragPoint: Identifiable, Hashable {
        
        var id: CGFloat { targetPrecent }
        let targetPrecent: CGFloat
        
        init!(targetPrecent: CGFloat) {
            
            if (0.0...1.0).contains(targetPrecent) {
                
                self.targetPrecent = targetPrecent
                
            } else {
                
                return nil
            }
        }
        
        private let insetForRange: CGFloat = 0.15
        
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
