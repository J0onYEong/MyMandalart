//
//  FocusTextView.swift
//  DesignSystem
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

public class FocusTextView: UIView, UITextViewDelegate {
    
    private let textView: UITextView = .init()
    private let placeHolderLabel: UILabel = .init()
    
    private var focusLineLayer1: CAShapeLayer?
    private var focusLineLayer2: CAShapeLayer?
    
    private let placeholderText: String
    private let focusColor: CGColor
    
    private let disposeBag: DisposeBag = .init()
    
    public var rx: Reactive<UITextView> { textView.rx }
    
    public init(placeholderText: String, focusColor: UIColor) {
        
        self.placeholderText = placeholderText
        self.focusColor = focusColor.cgColor
        
        super.init(frame: .zero)
        
        setTextView()
        
        setLayer()
        
        setLayout()
        
        subscribeToFocusEvent()
    }
    public required init?(coder: NSCoder) { nil }
    
    
    private func setTextView() {
        
        placeHolderLabel.text = self.placeholderText
        placeHolderLabel.textColor = UIColor.gray.withAlphaComponent(0.5)
        
        
    }
    
    private func setLayer() {
        
        layer.cornerRadius = 15
    }
    
    private func setLayout() {
        
        addSubview(textView)
        
        textView.snp.makeConstraints { make in
            
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(15)
            
            make.width.equalTo(100)
        }
        
        textView.addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { make in
            
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    // MARK: ReactiveUI
    private func subscribeToFocusEvent() {
        
        textView.rx.isFirstResponder
            .subscribe(onNext: { [weak self] isFocused in
                guard let self = self else { return }
                if isFocused {
                    self.startFocusLineAnimation(
                        duration: 0.2,
                        endPosForX: self.layer.cornerRadius
                    )
                } else {
                    self.dismissFocusLineAnimation(duration: 0.2)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    
    // MARK: Animations
    private func startFocusLineAnimation(duration: CFTimeInterval, endPosForX: CGFloat) {
        
        [
            focusLineLayer1,
            focusLineLayer2
        ].forEach { layer in
            
            layer?.removeAllAnimations()
            layer?.removeFromSuperlayer()
        }
        
        playFocusLine1(duration: duration, endPosForX: endPosForX, focusColor: self.focusColor)
        playFocusLine2(duration: duration, endPosForX: endPosForX, focusColor: self.focusColor)
        
    }
    
    private func dismissFocusLineAnimation(duration: CFTimeInterval) {
        
        dismissFocusLineAnimation1(duration: duration)
        dismissFocusLineAnimation2(duration: duration)
    }
    
}

// MARK: Dismiss focus line

private extension FocusTextView {
    
    func dismissFocusLineAnimation1(duration: CFTimeInterval) {
        
        guard let focusLineLayer1 else { return }
        
        
        let animation: CABasicAnimation = .init(keyPath: "strokeEnd")
        
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = duration
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        focusLineLayer1.add(animation, forKey: "unfocus-line-animation1")
    }
    
    func dismissFocusLineAnimation2(duration: CFTimeInterval) {
        
        guard let focusLineLayer2 else { return }
        
        
        let animation: CABasicAnimation = .init(keyPath: "strokeEnd")
        
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = duration
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        focusLineLayer2.add(animation, forKey: "unfocus-line-animation2")
    }
}


// MARK: Display focus line
private extension FocusTextView {
    
    func playFocusLine1(duration: CFTimeInterval, endPosForX: CGFloat, focusColor: CGColor) {
        
        let focusLineLayer: CAShapeLayer = .init()
        let cornerRadius = layer.cornerRadius
        focusLineLayer.frame = layer.bounds
        
        let path: CGMutablePath = .init()
        let rect = focusLineLayer.bounds
        
        path.move(to: .init(x: rect.midX, y: rect.maxY))
        
        path.addLine(
            to: .init(x: rect.minX+cornerRadius, y: rect.maxY)
        )
        
        path.addQuadCurve(
            to: .init(x: rect.minX, y: rect.maxY-cornerRadius),
            control: .init(x: rect.minX, y: rect.maxY)
        )
        
        path.addLine(to: .init(x: rect.minX, y: rect.minY+cornerRadius))
        
        path.addQuadCurve(
            to: .init(x: rect.minX+cornerRadius, y: rect.minY),
            control: .init(x: rect.minX, y: rect.minY)
        )
        
        path.addLine(to: .init(x: endPosForX, y: rect.minY))
        
        focusLineLayer.path = path
        focusLineLayer.strokeColor = focusColor
        focusLineLayer.fillColor = UIColor.clear.cgColor
        focusLineLayer.lineWidth = 1
        focusLineLayer.strokeEnd = 0
        
        self.layer.addSublayer(focusLineLayer)
        self.focusLineLayer1 = focusLineLayer
        
        // MARK: Animation
        let animation: CABasicAnimation = .init(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        focusLineLayer.add(animation, forKey: "focus-line-animation1")
    }
    
    func playFocusLine2(duration: CFTimeInterval, endPosForX: CGFloat, focusColor: CGColor) {
        
        let focusLineLayer: CAShapeLayer = .init()
        let cornerRadius = layer.cornerRadius
        focusLineLayer.frame = layer.bounds
        
        let path: CGMutablePath = .init()
        let rect = focusLineLayer.bounds
        
        path.move(to: .init(x: rect.midX, y: rect.maxY))
        
        path.addLine(
            to: .init(x: rect.maxX-cornerRadius, y: rect.maxY)
        )
        
        path.addQuadCurve(
            to: .init(x: rect.maxX, y: rect.maxY-cornerRadius),
            control: .init(x: rect.maxX, y: rect.maxY)
        )
        
        path.addLine(to: .init(x: rect.maxX, y: rect.minY+cornerRadius))
        
        path.addQuadCurve(
            to: .init(x: rect.maxX-cornerRadius, y: rect.minY),
            control: .init(x: rect.maxX, y: rect.minY)
        )
        
        path.addLine(to: .init(x: endPosForX, y: rect.minY))
        
        focusLineLayer.path = path
        focusLineLayer.strokeColor = focusColor
        focusLineLayer.fillColor = UIColor.clear.cgColor
        focusLineLayer.lineWidth = 1
        focusLineLayer.strokeEnd = 0
        
        self.layer.addSublayer(focusLineLayer)
        self.focusLineLayer2 = focusLineLayer
        
        // MARK: Animation
        let animation: CABasicAnimation = .init(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        focusLineLayer.add(animation, forKey: "focus-line-animation1")
    }
}

fileprivate extension Reactive where Base == UITextView {
    var isFirstResponder: Observable<Bool> {
        Observable.merge(
            didBeginEditing.map { true },
            didEndEditing.map { false }
        )
    }
}

