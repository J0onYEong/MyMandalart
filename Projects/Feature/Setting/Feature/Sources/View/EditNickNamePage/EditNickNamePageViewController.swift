//
//  EditNickNamePageViewController.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import UIKit

import SharedDesignSystem

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift

class EditNickNamePageViewController: UIViewController, View {
    
    // Sub view
    private let navigationBarView: NavigationBarView = .init()
    private let titleLabel: UILabel = .init()
    private let nickNameConditionLabel: UILabel = .init()

    private var inputContainer: UIView!
    private let nickNameInputField: FocusTextField = .init()
    private let confirmButton: ConfirmButton = .init()
    
    var disposeBag: DisposeBag = .init()
    
    init(reactor: EditNickNamePageViewModel) {
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
        
        
        // navigationBarView
        navigationBarView.update("닉네임 재설정 화면")
        
        
        // titleLabel
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.text = "변경할 닉네임을 알려주세요"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        
        
        // nickNameConditionLabel
        nickNameConditionLabel.font = .preferredFont(forTextStyle: .body)
        nickNameConditionLabel.text = "닉네임은 3자이상 입력해주세요!"
        nickNameConditionLabel.textAlignment = .left
        nickNameConditionLabel.textColor = .gray
        
        
        // nickNameInputField
        nickNameInputField.setPlaceholderText("새로운 닉네임 입력")
        nickNameInputField.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        
        
        // confirmButton
        confirmButton.setTitle("완료")
    }
    
    
    private func setLayout() {
        
        // navigationBarView
        view.addSubview(navigationBarView)
        
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
        }
        
        
        // labels
        let labelStack: UIStackView = .init(arrangedSubviews: [
            titleLabel, nickNameConditionLabel
        ])
        labelStack.axis = .vertical
        labelStack.alignment = .fill
        view.addSubview(labelStack)
        
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom).inset(-10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(10)
        }
        
        
        // input and button
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
    
    
    func bind(reactor: EditNickNamePageViewModel) {
        
        // Bind, navigationBarView
        navigationBarView.rx.tap
            .map { Reactor.Action.exitPageButtonClicked }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
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
private extension EditNickNamePageViewController {
    
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
