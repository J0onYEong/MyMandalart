//
//  EditMainMandaratView.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import SharedDesignSystem

import ReactorKit
import SnapKit

// id, imageURL, title, story, hexColor

class EditMainMandaratView: UIView, View {
    
    // Sub View
    private let backgroundView: TappableView = .init()
    private let titleInputView: FocusTextField = .init()
    private let descriptionInputView: FocusTextView = .init()
    private let inputContainerBackView: UIView = .init()
    
    private var isLayerIsSetted = false
    
    var reactor: EditMainMandaratViewModel?
    var disposeBag: DisposeBag = .init()
    
    init() {
        
        super.init(frame: .zero)
        
        setBackgroundView()
        setInputFields()
        setLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isLayerIsSetted {
            isLayerIsSetted = true
            
            setInputContainerView()
        }
    }
    
    public func onAppearTask() {
        
        // MARK: Animation
        backgroundView.alpha = 0.0
        
        UIView.animate(withDuration: 0.35) {
            
            self.backgroundView.alpha = 1
        }
            
        // MARK: Keyboard
        titleInputView.becomeFirstResponder()
    }
    
    private func setBackgroundView() {
        
        backgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    }
    
    private func setInputFields() {
        
        titleInputView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        titleInputView.setFocusLineColor(.gray)
        titleInputView.setPlaceholderText("만다라트 주제를 입력해주세요!")
        
        descriptionInputView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        descriptionInputView.setFocusLineColor(.gray)
        descriptionInputView.setPlaceholderText("목표를 설명해주세요!")
    }
    
    private func setLayout() {
        
        
        // MARK: backgroundView
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        // MARK: inputContainerBackView
        addSubview(inputContainerBackView)
        
        inputContainerBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        // MARK: inputStackView
        let inputStackView: UIStackView = .init(arrangedSubviews: [
            titleInputView,
            descriptionInputView,
        ])
        inputStackView.axis = .vertical
        inputStackView.spacing = 15
        inputStackView.alignment = .fill
        inputStackView.distribution = .fill
        
        inputContainerBackView.addSubview(inputStackView)
        
        descriptionInputView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        inputStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func bind(reactor: EditMainMandaratViewModel) {
        
        self.reactor = reactor

        // titleInputView
        reactor.state
            .map(\.titleText)
            .take(1)
            .bind(to: titleInputView.rx.text)
            .disposed(by: disposeBag)
        
        titleInputView.rx.text
            .compactMap({ $0 })
            .map { text in
                return Reactor.Action.editTitleText(text: text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        
        // descriptionInputView
        reactor.state
            .map(\.descriptionText)
            .take(1)
            .bind(to: descriptionInputView.text)
            .disposed(by: disposeBag)
        
//        descriptionInputView.rx.text
//            .compactMap({ $0 })
//            .map { text in
//                return Reactor.Action.editDescriptionText(text: text)
//            }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
    }
}


// MARK: InputContainerView drawing
private extension EditMainMandaratView {
    
    func setInputContainerView() {
        
        inputContainerBackView.backgroundColor = .white
        
        let shapeLayer: CAShapeLayer = .init()
        shapeLayer.frame = inputContainerBackView.bounds
        
        let rect = shapeLayer.bounds
        let minRadius: CGFloat = 30
        let maxRadius: CGFloat = 90
        let path = CGMutablePath()
        path.move(to: .init(x: rect.minX, y: rect.maxY))
        
        path.addLine(to: .init(x: rect.minX, y: minRadius))
        
        path.addCurve(
            to: .init(x: maxRadius, y: rect.minY),
            control1: .init(x: rect.minX, y: rect.minY),
            control2: .init(x: rect.minX, y: rect.minY)
        )
        
        path.addLine(to: .init(x: rect.maxX-maxRadius, y: rect.minY))
        
        path.addCurve(
            to: .init(x: rect.maxX, y: minRadius),
            control1: .init(x: rect.maxX, y: rect.minY),
            control2: .init(x: rect.maxX, y: rect.minY)
        )
        
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        shapeLayer.path = path
        shapeLayer.strokeEnd = 1
        shapeLayer.fillColor = UIColor.white.cgColor
        
        inputContainerBackView.layer.mask = shapeLayer
    }
    
}
