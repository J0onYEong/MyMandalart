//
//  NickNameInputPageViewController.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import UIKit

import SharedDesignSystem

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift

class NickNameInputPageViewController: UIViewController, View {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private let nickNameConditionLabel: UILabel = .init()

    private var inputContainer: UIView!
    private let nickNameInputField: FocusTextField = .init()
    private let confirmButton: ConfirmButton = .init()
    
    var disposeBag: DisposeBag = .init()
    
    init(reactor: NickNameInputPageViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        subscribeToKeyboardEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nickNameInputField.becomeFirstResponder()
    }
    
    private func setUI() {
        
        // view
        view.backgroundColor = .white
        
        
        // titleLabel
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.text = "안녕하세요! 사용하실 닉네임을 알려주세요"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        
        
        // nickNameConditionLabel
        nickNameConditionLabel.font = .preferredFont(forTextStyle: .body)
        nickNameConditionLabel.text = "닉네임은 3자이상 입력해주세요!"
        nickNameConditionLabel.textAlignment = .left
        nickNameConditionLabel.textColor = .gray
        
        
        // nickNameInputField
        nickNameInputField.setPlaceholderText("닉네임 입력")
        
        
        // confirmButton
        confirmButton.setTitle("만다라트 작성 시작하기!")
    }
    
    
    private func setLayout() {
        
        let labelStack: UIStackView = .init(arrangedSubviews: [
            titleLabel, nickNameConditionLabel
        ])
        labelStack.axis = .vertical
        labelStack.alignment = .fill
        view.addSubview(labelStack)
        
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(10)
        }
        
        
        let inputStack: UIStackView = .init(arrangedSubviews: [
            nickNameInputField, confirmButton
        ])
        inputStack.axis = .vertical
        inputStack.spacing = 20
        inputStack.alignment = .fill
        inputStack.backgroundColor = .white
        view.addSubview(inputStack)
        
        inputStack.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        self.inputContainer = inputStack
    }
    
    
    func bind(reactor: NickNameInputPageViewModel) {
        
        // Bind, Text field
        nickNameInputField.rx.text
            .compactMap({ $0 })
            .map { Reactor.Action.editNickName(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind, confirmButton
        reactor.state
            .distinctDriver(\.completeButtonEnabled)
            .drive(confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { _ in Reactor.Action.completeButtonClicked }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}


// MARK: Keyboard avoidence
private extension NickNameInputPageViewController {
    
    func subscribeToKeyboardEvent() {
        
        NotificationCenter.default.rx
            .notification(UIApplication.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notfication in
                
                guard
                    let self,
                    let keyboardFrame = notfication.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                    let keyboardDisplayDuration = notfication.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                else { return }
                
                let viewMaxY = inputContainer.frame.maxY
                let keyboardY = keyboardFrame.minY
                
                if viewMaxY > keyboardY {
                    
                    let gap = viewMaxY - keyboardY
                    
                    UIView.animate(withDuration: keyboardDisplayDuration) {
                        
                        self.inputContainer.transform = self.inputContainer.transform.translatedBy(x: 0, y: -gap)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIApplication.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] notfication in
                
                guard
                    let self,
                    let keyboardDisplayDuration = notfication.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                else { return }
                
                UIView.animate(withDuration: keyboardDisplayDuration) {
                    
                    self.inputContainer.transform = .identity
                }
            })
            .disposed(by: disposeBag)
    }
}
