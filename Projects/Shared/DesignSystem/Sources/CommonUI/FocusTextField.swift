//
//  FocusTextField.swift
//  DesignSystem
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

public class FocusTextField: UIView {
    
    private let textField: UITextField = .init()
    
    private var focusLineLayer1: CAShapeLayer?
    private var focusLineLayer2: CAShapeLayer?
    
    private let placeholderText: String
    
    private let disposeBag: DisposeBag = .init()
    
    public var rx: Reactive<UITextField> { textField.rx }
    
    public init(placeholderText: String) {
        
        self.placeholderText = placeholderText
        
        super.init(frame: .zero)
        
        setTextField()
        
        setLayer()
        
        setTextFieldLayout()
        
        subscribeToFocusEvent()
    }
    public required init?(coder: NSCoder) { nil }
    
    
    private func setTextField() {
        
        textField.placeholder = placeholderText
        
    }
    
    private func setTextFieldLayout() {
        
        addSubview(textField)
        
        textField.snp.makeConstraints { make in
            
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(15)
            
            make.width.equalTo(100)
        }
    }
    
    private func setLayer() {
        
        layer.cornerRadius = 15
    }
    
    
    // MARK: ReactiveUI
    private func subscribeToFocusEvent() {
        
        textField.rx.controlEvent(.editingDidBegin)
            .withUnretained(self)
            .subscribe(onNext: { view, _ in
                
                view.startFocusLineAnimation(
                    duration: 0.2,
                    endPosForX: view.layer.cornerRadius
                )
            })
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .subscribe(onNext: { view, _ in
                
                view.dismissFocusLineAnimation(
                    duration: 0.2
                )
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
        
        playFocusLine1(duration: duration, endPosForX: endPosForX)
        playFocusLine2(duration: duration, endPosForX: endPosForX)
        
    }
    
    private func dismissFocusLineAnimation(duration: CFTimeInterval) {
        
        dismissFocusLineAnimation1(duration: duration)
        dismissFocusLineAnimation2(duration: duration)
    }
    
}

// MARK: Dismiss focus line

private extension FocusTextField {
    
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
private extension FocusTextField {
    
    func playFocusLine1(duration: CFTimeInterval, endPosForX: CGFloat) {
        
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
        focusLineLayer.strokeColor = UIColor.black.cgColor
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
    
    func playFocusLine2(duration: CFTimeInterval, endPosForX: CGFloat) {
        
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
        focusLineLayer.strokeColor = UIColor.black.cgColor
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

#Preview {
    
    let stack: UIStackView = .init(arrangedSubviews: [
        FocusTextField(placeholderText: "Test1"),
        FocusTextField(placeholderText: "Test2"),
    ])
    stack.axis = .vertical
    
    return stack
}
