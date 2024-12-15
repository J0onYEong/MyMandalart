//
//  FocusTextView.swift
//  DesignSystem
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public class FocusTextView: UIView, UITextViewDelegate {
    
    private let textView: UITextView = .init()
    private let placeHolderLabel: UILabel = .init()
    
    private var focusLineLayer1: CAShapeLayer?
    private var focusLineLayer2: CAShapeLayer?
    
    private let placeholderText: String = ""
    private var focusColor: CGColor = UIColor.black.cgColor
    
    private let disposeBag: DisposeBag = .init()
    
    public let text: BehaviorSubject<String?> = .init(value: nil)
    
    
    public init() {
        
        super.init(frame: .zero)
        
        setTextView()
        
        setLayer()
        
        setLayout()
        
        text
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { view, text in
                view.textView.text = text
            })
            .disposed(by: disposeBag)
    }
    public required init?(coder: NSCoder) { nil }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 변경될 뷰의 레이어의 크기로 재조정
        if isFirstResponder {
            
            focusLineLayer1?.removeAnimation(forKey: "focus-line-animation1")
            focusLineLayer1?.frame = layer.bounds
            focusLineLayer1?.path = drawFocusLine1(
                rect: layer.bounds,
                cornerRadius: layer.cornerRadius,
                endPosForX: layer.cornerRadius
            )
            focusLineLayer1?.strokeEnd = 1
            
            focusLineLayer2?.removeAnimation(forKey: "focus-line-animation2")
            focusLineLayer2?.frame = layer.bounds
            focusLineLayer2?.path = drawFocusLine2(
                rect: layer.bounds,
                cornerRadius: layer.cornerRadius,
                endPosForX: layer.cornerRadius
            )
            focusLineLayer2?.strokeEnd = 1
        }
    }
    
    
    public func setPlaceholderText(_ text: String) {
        placeHolderLabel.text = text
    }
    
    
    public func setFocusLineColor(_ color: UIColor) {
        self.focusColor = color.cgColor
        
        focusLineLayer1?.strokeColor = self.focusColor
        focusLineLayer2?.strokeColor = self.focusColor
    }
    
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }
    
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        textView.resignFirstResponder()
    }
    
    
    public override var isFirstResponder: Bool {
        textView.isFirstResponder
    }
    
    
    private func setTextView() {
        
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        
        placeHolderLabel.text = self.placeholderText
        placeHolderLabel.font = .preferredFont(forTextStyle: .body)
        placeHolderLabel.backgroundColor = .clear
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
        }
        
        textView.addSubview(placeHolderLabel)
        
        let horizontalInset = textView.textContainerInset.left + textView.textContainer.lineFragmentPadding
        
        placeHolderLabel.snp.makeConstraints { make in
            
            make.top.equalToSuperview().inset(textView.textContainerInset.top)
            make.leading.equalToSuperview().inset(horizontalInset)
        }
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

// MARK: TextView delegate
extension FocusTextView {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""

        if let textRange = Range(range, in: currentText) {
            
            let updatedText = currentText.replacingCharacters(in: textRange, with: text)
            
            self.text.onNext(updatedText)
            placeHolderLabel.isHidden = !updatedText.isEmpty
        }
        
        return true
    }
    
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        startFocusLineAnimation(
            duration: 0.2,
            endPosForX: self.layer.cornerRadius
        )
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        
        dismissFocusLineAnimation(duration: 0.2)
    }
}


// MARK: Dismiss focus line
private extension FocusTextView {
    
    func drawFocusLine1(rect: CGRect, cornerRadius: CGFloat, endPosForX: CGFloat) -> CGPath {
        
        let path: CGMutablePath = .init()
        
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
        
        return path
    }
    
    
    func drawFocusLine2(rect: CGRect, cornerRadius: CGFloat, endPosForX: CGFloat) -> CGPath {
        
        let path: CGMutablePath = .init()
        
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
        
        return path
    }
    
    
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
        focusLineLayer.path = drawFocusLine1(rect: focusLineLayer.bounds, cornerRadius: cornerRadius, endPosForX: endPosForX)
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
        focusLineLayer.path = drawFocusLine2(rect: focusLineLayer.bounds, cornerRadius: cornerRadius, endPosForX: endPosForX)
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
