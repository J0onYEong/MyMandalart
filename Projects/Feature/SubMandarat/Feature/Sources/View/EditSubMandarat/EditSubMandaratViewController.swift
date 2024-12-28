//
//  EditSubMandaratViewController.swift
//  Home
//
//  Created by choijunios on 12/15/24.
//

import UIKit

import SharedDesignSystem

import ReactorKit
import RxSwift
import RxCocoa

class EditSubMandaratViewController: UIViewController, View {
    
    // Sub view
    private let backgroundView: TappableView = .init()
    private let titleInputView: FocusTextField = .init()
    private let acheivementRateView: AdjustAcheivementRateView = .init()
    private let inputSheetView: UIView = .init()
    
    // - Tool button
    private let exitButton: ImageButton = .init(imageName: "xmark")
    private let saveButton: TextButton = .init(text: "저장")
    
    
    // Transition
    private let transitionDelegate = TransitionDelegate()
    
    
    // Reactor
    var reactor: EditSubMandartViewModel?
    var disposeBag: DisposeBag = .init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.transitioningDelegate = transitionDelegate
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBackgroundView()
        setLayout()
        subscribeToKeyboardEvent()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layoutIfNeeded()
        
        // MARK: Keyboard
        titleInputView.becomeFirstResponder()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setInputContainerViewShape()
    }
    
    
    private func setUI() {
        
        view.backgroundColor = .clear
        backgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        
        titleInputView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        titleInputView.setPlaceholderText("목표정보를 입력해주세요!")
    }
    
    
    private func setBackgroundView() {
        
        let tapGesture: UITapGestureRecognizer = .init()
        backgroundView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(onBackgroundViewTapped))
    }
    
    
    @objc private func onBackgroundViewTapped() {
        
        // 배경 클릭시 리스폰더 해제
        if titleInputView.isFirstResponder {
            
            titleInputView.resignFirstResponder()
        }
    }
    
    
    private func setLayout() {
        
        // MARK: backgroundView
        view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        // MARK: inputContainerBackView
        view.addSubview(inputSheetView)
        
        inputSheetView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
        
        
        // MARK: toolButtonStack
        let toolButtonStack: UIStackView = .init(
            arrangedSubviews: [saveButton, exitButton]
        )
        toolButtonStack.axis = .horizontal
        toolButtonStack.spacing = 5
        toolButtonStack.distribution = .fill
        toolButtonStack.alignment = .fill
        
        inputSheetView.addSubview(toolButtonStack)
        
        toolButtonStack.snp.makeConstraints { make in
            
            make.top.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(20)
        }
        
        
        // MARK: inputStackView
        let inputStackView: UIStackView = .init(arrangedSubviews: [
            titleInputView,
            acheivementRateView,
        ])
        inputStackView.axis = .vertical
        inputStackView.spacing = 12
        inputStackView.alignment = .fill
        inputStackView.distribution = .fill
        
        inputSheetView.addSubview(inputStackView)
        
        inputStackView.snp.makeConstraints { make in
            make.top.equalTo(toolButtonStack.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}


// MARK: View
extension EditSubMandaratViewController {
    
    func bind(reactor: EditSubMandartViewModel) {
        
        self.reactor = reactor
        
        // Bind, textfield
        reactor.state
            .map(\.titleText)
            .bind(to: titleInputView.rx.text)
            .disposed(by: disposeBag)
        
        titleInputView.rx.text
            .compactMap({ $0 })
            .distinctUntilChanged()
            .map({ Reactor.Action.titleChanged(text: $0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind, acheivementRateView
        reactor.state
            .map(\.acheiveRate)
            .take(1)
            .map({ CGFloat($0) })
            .bind(to: acheivementRateView.rx.dragPecent)
            .disposed(by: disposeBag)
        
        acheivementRateView.rx.dragPecent
            .distinctUntilChanged()
            .map({ Reactor.Action.acheivePercentChanged(percent: $0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind, Buttons
        exitButton.rx.tap
            .map({ Reactor.Action.exitButtonClicked })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .map({ Reactor.Action.saveButtonClicked })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind, alert
        reactor.state
            .compactMap(\.alertData)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] alertData in
                
                guard let self else { return }
                
                let alertView = createAlertView()
                
                // set ui
                alertView.update(
                    title: alertData.title,
                    description: alertData.description,
                    backgroundColor: alertData.alertColor
                )
                
                
                // present anim
                alertView.layoutIfNeeded()
                let height = alertView.bounds.height
                
                alertView.transform = alertView.transform.translatedBy(x: 0, y: height)
                alertView.alpha = 0
                
                UIView.animate(withDuration: 0.35) {
                    
                    alertView.alpha = 1
                    alertView.transform = .identity
                    
                } completion: { _ in
                    
                    UIView.animate(withDuration: 0.1, delay: 1) {
                        
                        alertView.alpha = 0
                        
                    } completion: { _ in
                        
                        alertView.removeFromSuperview()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: InputContainerView drawing
private extension EditSubMandaratViewController {
    
    func setInputContainerViewShape() {
        
        inputSheetView.backgroundColor = .white
        
        let shapeLayer: CAShapeLayer = .init()
        shapeLayer.frame = inputSheetView.bounds
        
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
        
        inputSheetView.layer.mask = shapeLayer
    }
    
}


// MARK: Transition
private extension EditSubMandaratViewController {
    
    func onAppearTask(duration: CFTimeInterval, context: UIViewControllerContextTransitioning) {
        
        let containerView = context.containerView
        containerView.addSubview(view)
        
        // MARK: Animation
        view.layoutIfNeeded()
        let height = self.inputSheetView.layer.bounds.height
        inputSheetView.transform = .init(translationX: 0, y: height)
        backgroundView.alpha = 0
        
        UIView.animate(withDuration: duration) {
            
            self.backgroundView.alpha = 1
            
            self.inputSheetView.transform = .identity
            
        } completion: { completed in
            
            context.completeTransition(completed)
        }
    }
    
    func onDissmissTask(duration: CFTimeInterval, context: UIViewControllerContextTransitioning) {
        
        UIView.animate(withDuration: duration) {
            
            self.backgroundView.alpha = 0
            
            let height = self.inputSheetView.layer.bounds.height
            self.inputSheetView.transform = .init(translationX: 0, y: height)
            
        } completion: { [weak self] completed in
            
            self?.view.removeFromSuperview()
            context.completeTransition(completed)
        }
    }
    
    class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
        
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
            PresentAnimation()
        }
        
        func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
            DismissAnimation()
        }
    }
    
    class PresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.25
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let viewController = transitionContext.viewController(forKey: .to) as? EditSubMandaratViewController else { return }
            
            viewController.onAppearTask(
                duration: transitionDuration(using: transitionContext),
                context: transitionContext
            )
        }
    }

    class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.25
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let viewController = transitionContext.viewController(forKey: .from) as? EditSubMandaratViewController else { return }
            
            viewController.onDissmissTask(
                duration: transitionDuration(using: transitionContext),
                context: transitionContext
            )
        }
    }
}



private extension EditSubMandaratViewController {
    
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
                    
                    vc.inputSheetView.snp.updateConstraints { make in
                        
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
                    
                    vc.inputSheetView.snp.updateConstraints { make in
                        
                        make.bottom.equalToSuperview()
                    }
                    
                    vc.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}



// MARK: Alert
extension EditSubMandaratViewController {
    
    func createAlertView() -> ToastView {
        
        let toastView: ToastView = .init()
        
        inputSheetView.addSubview(toastView)
        
        toastView.snp.makeConstraints { make in
            
            make.bottom.equalToSuperview().inset(10).priority(.low)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).priority(.high)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        return toastView
    }
}
