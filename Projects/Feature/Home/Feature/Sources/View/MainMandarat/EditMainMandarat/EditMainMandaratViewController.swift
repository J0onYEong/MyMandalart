//
//  EditMainMandaratViewController.swift
//  Home
//
//  Created by choijunios on 12/9/24.
//

import UIKit

import SharedDesignSystem

import ReactorKit
import SnapKit

// id, imageURL, title, story, hexColor

class EditMainMandaratViewController: UIViewController, View, UIColorPickerViewControllerDelegate {
    
    // Sub View
    private let titleInputView: FocusTextField = .init()
    private let descriptionInputView: FocusTextView = .init()
    private let inputContainerBackView: UIView = .init()
    private let colorSelectionView: ColorSelectionView = .init(labelText: "대표 색상 변경")
    
    private var isLayerIsSetted = false
    
    var reactor: EditMainMandaratViewModel?
    private let selectedColor: PublishSubject<UIColor> = .init()
    private let colorPickerClosed: PublishSubject<Void> = .init()
    var disposeBag: DisposeBag = .init()
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundView()
        setInputFields()
        setLayout()
        subscribeToKeyboardEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layoutIfNeeded()
        onAppearTask()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isLayerIsSetted {
            isLayerIsSetted = true
            
            setInputContainerView()
        }
    }
    
    
    private func onAppearTask() {
        
        // MARK: Animation
        view.alpha = 0.0
        
        UIView.animate(withDuration: 0.35) {
            
            self.view.alpha = 1
        }
        
        // MARK: Keyboard
        titleInputView.becomeFirstResponder()
    }
    
    private func setBackgroundView() {
        
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        let tapGesture: UITapGestureRecognizer = .init()
        view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(onBackgroundViewTapped))
    }
    @objc private func onBackgroundViewTapped() {
        
        [
            titleInputView,
            descriptionInputView
        ].forEach { responder in
            if responder.isFirstResponder {
                responder.resignFirstResponder()
            }
        }
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
        
        // MARK: inputContainerBackView
        view.addSubview(inputContainerBackView)
        
        inputContainerBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // MARK: colorSelectionView
        let colorSelectionStackView: UIStackView = .init(
            arrangedSubviews: [colorSelectionView, UIView()]
        )
        colorSelectionStackView.axis = .horizontal
        colorSelectionStackView.distribution = .fill
        colorSelectionStackView.alignment = .center
        
        
        // MARK: inputStackView
        let inputStackView: UIStackView = .init(arrangedSubviews: [
            colorSelectionStackView,
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

        // MARK: Bind, titleInputView
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
            
        
        // MARK: Bind, descriptionInputView
        reactor.state
            .map(\.descriptionText)
            .take(1)
            .bind(to: descriptionInputView.text)
            .disposed(by: disposeBag)
        
        descriptionInputView.text
            .compactMap({ $0 })
            .map { text in
                return Reactor.Action.editDescriptionText(text: text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // MARK: color selection
        reactor.state
            .compactMap(\.mandaratTitleColor)
            .bind(to: colorSelectionView.rx.color)
            .disposed(by: disposeBag)
        
        reactor.state
            .distinctUntilChanged(at: \.presentColorPicker)
            .filter(\.presentColorPicker)
            .map(\.mandaratTitleColor)
            .withUnretained(self)
            .subscribe(onNext: { vc, prevColor in
                vc.presentColorPicker(
                    titleText: "만다라트 대표 색상",
                    previousColor: prevColor
                )
            })
            .disposed(by: disposeBag)
        
        selectedColor
            .map { color in
                Reactor.Action.editColor(color: color)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        colorPickerClosed
            .map { _ in
                Reactor.Action.colorPickerClosed
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        colorSelectionView.rx.colorSelectionTap
            .map { _ in
                Reactor.Action.colorSelectionButtonClicked
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: Bind background tapped
        
    }
}


// MARK: InputContainerView drawing
private extension EditMainMandaratViewController {
    
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

// MARK: Color picker
extension EditMainMandaratViewController {
    
    private func presentColorPicker(
        titleText: String,
        previousColor: UIColor?
    ) {
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = titleText
        colorPicker.selectedColor = .blue
        colorPicker.supportsAlpha = true
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        if let previousColor {
            colorPicker.selectedColor = previousColor
        }
        
        self.present(colorPicker, animated: true)
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorPickerClosed.onNext(())
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        self.selectedColor.onNext(color)
    }
}

private extension EditMainMandaratViewController {
    
    func subscribeToKeyboardEvent() {
        
        NotificationCenter.default.rx
            .notification(UIApplication.keyboardWillShowNotification)
            .withUnretained(self)
            .subscribe(onNext: { vc, notfication in
                
                guard
                    let keyboardFrame = notfication.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                    let keyboardDisplayDuration = notfication.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                else { return }
                
                UIView.animate(withDuration: keyboardDisplayDuration) {
                    
                    vc.inputContainerBackView.snp.updateConstraints { make in
                        
                        make.bottom.equalToSuperview().inset(CGFloat(keyboardFrame.height))
                    }
                    
                    vc.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIApplication.keyboardWillHideNotification)
            .withUnretained(self)
            .subscribe(onNext: { vc, notfication in
                
                guard
                    let keyboardDisplayDuration = notfication.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                else { return }
                
                UIView.animate(withDuration: keyboardDisplayDuration) {
                    
                    vc.inputContainerBackView.snp.updateConstraints { make in
                        
                        make.bottom.equalToSuperview()
                    }
                    
                    vc.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}
