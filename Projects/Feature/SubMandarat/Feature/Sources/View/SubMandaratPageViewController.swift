//
//  SubMandaratViewController.swift
//  Home
//
//  Created by choijunios on 12/11/24.
//

import UIKit

import DomainMandaratInterface
import SharedDesignSystem

import ReactorKit
import RxSwift
import RxCocoa

class SubMandaratPageViewController: UIViewController, SubMandaratPageViewControllable, View {
    
    // Sub view
    private let mainMandaratDescriptionView: MainMandaratDescriptionView = .init()
    fileprivate var subMandaratViews: [MandaratPosition: SubMandaratView] = [:]
    fileprivate var subMandaratViewsExceptForCenter: [MandaratPosition: SubMandaratView] {
        subMandaratViews.filter { key, _ in key != .TWO_TWO }
    }
    fileprivate let centerMandaratView: CenterMandaratView = .init()
    fileprivate var subMandaratContainerView: UIStackView!
    private let returnButton: ReturnButton = .init()
    
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    
    // UINavigationControllerDelegate
    let transitionDelegate: UINavigationControllerDelegate = SubMandaratViewControllerTransitionDelegate()
    
    
    // Reactor
    var reactor: SubMandaratPageViewModel?
    var disposeBag: DisposeBag = .init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        createSubMandaratViews()
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        
        view.layoutIfNeeded()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let deviceOrientation = UIDevice.current.orientation
        
        switch deviceOrientation {
        case .portrait:
            
            fitLayoutTo(mode: .portrait)
            
        case .landscapeRight, .landscapeLeft:
            
            fitLayoutTo(mode: .landscape)
            
        default:
            return
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reactor?.action.onNext(.viewDidAppear)
    }
    
    
    private func setUI() {
        
        view.backgroundColor = .clear
        
        subMandaratViews[.TWO_TWO]?.alpha = 0
    }
    
    
    private func setLayout() {
        
        // Middle
        setSubMandaratViewLayout()
        setMainMandaratViewLayout()
        
        
        // Top
        setMainMandaratDescriptionViewLayout()
        
        
        // Bottom
        setReturnButtonLayout()
        
        // 최초 설정 : Portrait
        fitLayoutTo(mode: .portrait)
    }
    
    
    func bind(reactor: SubMandaratPageViewModel) {
        
        self.reactor = reactor
        
        view.layoutIfNeeded()
        
        
        // Bind, subMandaratViews
        reactor.subMandaratViewModels.forEach { position, viewModel in
            
            self.subMandaratViews[position]!.bind(reactor: viewModel)
        }
        
        
        // Bind, title & description
        reactor.state
            .distinctDriver(\.pageTitle)
            .drive(onNext: { [weak self] titleText in
                self?.mainMandaratDescriptionView.updateTitle(text: titleText)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .distinctDriver(\.pageDescription)
            .drive(onNext: { [weak self] descriptionText in
                self?.mainMandaratDescriptionView.updateDescription(text: descriptionText)
            })
            .disposed(by: disposeBag)
        
        
        // Bind, center mandarat
        reactor.state
            .map(\.centerMandarat)
            .withUnretained(self)
            .subscribe(onNext: { vc, centerMandaratVO in
                
                vc.centerMandaratView.render(centerMandaratVO)
            })
            .disposed(by: disposeBag)
        
        centerMandaratView.rx.tap
            .map({ _ in Reactor.Action.centerMandaratClicked })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind, return button
        returnButton.tap
            .map({ _ in Reactor.Action.returnButtonClicked })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind, Cancellable toast
        reactor.state
            .compactMap(\.cancellableToastData)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] toastData in
                
                guard let self else { return }
                
                let toastView = createCancellableToastView()
                
                toastView.update(
                    title: toastData.title,
                    description: toastData.description,
                    backgroundColor: toastData.backgroudColor
                )
                
                // present anim
                toastView.layoutIfNeeded()
                let height = toastView.bounds.height
                
                toastView.transform = toastView.transform.translatedBy(x: 0, y: height)
                toastView.alpha = 0
                
                UIView.animate(withDuration: 0.35) {
                    
                    toastView.alpha = 1
                    toastView.transform = .identity
                }
                
                // on cancel button clicked
                toastView.rx.cancelButtonTapped
                    .take(1)
                    .subscribe(onNext: { [weak toastView] _ in
                        
                        guard let toastView else { return }
                        
                        let height = toastView.bounds.height
                        
                        UIView.animate(withDuration: 0.35) {
                            
                            toastView.transform = toastView.transform.translatedBy(x: 0, y: height)
                            toastView.alpha = 0
                            
                        } completion: { _ in
                            
                            toastView.removeFromSuperview()
                        }
                    })
                    .disposed(by: disposeBag)
                
            })
            .disposed(by: disposeBag)
    }
}


// MARK: mainMandaratDescriptionView
private extension SubMandaratPageViewController {
    
    func setMainMandaratDescriptionViewLayout() {
        
        view.addSubview(mainMandaratDescriptionView)
        
        mainMandaratDescriptionView.snp.makeConstraints { make in
            
            portraitConstraints.append(contentsOf: [
                
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10).priority(.high).constraint.layoutConstraints.first!,
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(10).priority(.high).constraint.layoutConstraints.first!,
                make.right.equalTo(view.safeAreaLayoutGuide.snp.right).priority(.high).constraint.layoutConstraints.first!,
                make.bottom.lessThanOrEqualTo(subMandaratContainerView.snp.top).priority(.high).constraint.layoutConstraints.first!,
                
            ])
            
            landscapeConstraints.append(contentsOf: [
                
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10).priority(.high).constraint.layoutConstraints.first!,
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).priority(.high).constraint.layoutConstraints.first!,
                make.right.lessThanOrEqualTo(subMandaratContainerView.snp.left).priority(.high).constraint.layoutConstraints.first!,
                make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).priority(.high).constraint.layoutConstraints.first!,
                
            ])
        }
    }
}


// MARK: Sub mandarat views
private extension SubMandaratPageViewController {
    
    func setMainMandaratViewLayout() {
        
        view.addSubview(centerMandaratView)
        
        let middleCell: UIView = subMandaratViews[.TWO_TWO]!
        
        centerMandaratView.snp.makeConstraints { make in
            make.edges.equalTo(middleCell)
        }
    }
    
    func setSubMandaratViewLayout() {
        
        // MARK: Main mandarat views
        let mandaratRows: [[MandaratPosition]] = [
            
            // row1
            [.ONE_ONE, .ONE_TWO, .ONE_TRD],
            
            // row2
            [.TWO_ONE, .TWO_TWO, .TWO_TRD],
            
            // row3
            [.TRD_ONE, .TRD_TWO, .TRD_TRD],
        ]
        
        let rowStackViews: [UIStackView] = mandaratRows.map { rowItems in
            
            let stackView: UIStackView = .init(
                arrangedSubviews: getSubMandaratViews(rowItems)
            )
            stackView.axis = .horizontal
            stackView.spacing = 5
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            return stackView
        }
        
        let mainMandaratContainerStackView: UIStackView = .init(
            arrangedSubviews: rowStackViews
        )
        mainMandaratContainerStackView.axis = .vertical
        mainMandaratContainerStackView.spacing = 5
        mainMandaratContainerStackView.distribution = .fillEqually
        mainMandaratContainerStackView.alignment = .fill
        
        
        view.addSubview(mainMandaratContainerStackView)
        
        mainMandaratContainerStackView.snp.makeConstraints { make in
            
            portraitConstraints.append(contentsOf: [
                make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                    .constraint.layoutConstraints.first!,
                
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                    .constraint.layoutConstraints.first!,
                
                make.height.equalTo(mainMandaratContainerStackView.snp.width)
                    .constraint.layoutConstraints.first!,
                
                make.centerY.equalToSuperview()
                    .constraint.layoutConstraints.first!,
            ])
            
            landscapeConstraints.append(contentsOf: [
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                    .constraint.layoutConstraints.first!,
                
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                    .constraint.layoutConstraints.first!,
                
                make.width.equalTo(mainMandaratContainerStackView.snp.height)
                    .constraint.layoutConstraints.first!,
                
                make.centerX.equalToSuperview()
                    .constraint.layoutConstraints.first!,
            ])
        }
        
        self.subMandaratContainerView = mainMandaratContainerStackView
    }
    
    func createSubMandaratViews() {
        
        MandaratPosition.allCases.forEach { mandaratPosition in
            let view = SubMandaratView()
            self.subMandaratViews[mandaratPosition] = view
        }
    }
    
    func getSubMandaratViews(_ positions: [MandaratPosition]) -> [SubMandaratView] {
        
        return positions.map { position in
            
            self.subMandaratViews[position]!
        }
    }
}


extension SubMandaratPageViewController {
    
    func onAppearAnimation(duration: CFTimeInterval, context: UIViewControllerContextTransitioning) {
        
        // addSubView
        context.containerView.addSubview(self.view)
        
        
        // 모든 셀을 가운데 모으고 투명화한다.
        view.layoutIfNeeded()
        
        subMandaratViewsExceptForCenter.forEach { (key, subMandaratView) in
            
            subMandaratView.alpha = 0
            
            // 랜덤이동
            subMandaratView.moveOneInch(direction: .random)
        }
        
        // 중앙 메인 만다라트 뷰
        self.centerMandaratView.alpha = 0
        
        // 돌아가기 버튼
        self.returnButton.alpha = 0
        
        // 동시에 모든 셀을 사방으로 보낸다. + Animation
        UIView.animate(withDuration: duration) {
            
            self.subMandaratViewsExceptForCenter.values.forEach { subMandaratView in
                
                subMandaratView.moveToIdentity()
                subMandaratView.alpha = 1
            }
            
        } completion: { completed in
            
            self.view.backgroundColor = .white
            self.centerMandaratView.alpha = 1
            
            context.completeTransition(completed)
            
            UIView.animate(withDuration: 0.35) {
                
                self.returnButton.alpha = 1
            }
        }
    }
    
    
    func onDisappearAnimation(duration: CFTimeInterval, context: UIViewControllerContextTransitioning) {
        
        let containerView = context.containerView
        
        if let toView = context.view(forKey: .to) {
            
            containerView.insertSubview(toView, belowSubview: view)
        }
        
        UIView.animate(withDuration: duration) {
            
            self.mainMandaratDescriptionView.alpha = 0
            
            self.returnButton.alpha = 0
            
            self.view.subviews.forEach { subView in
            
                if subView is CancellableToastView {
                    
                    subView.alpha = 0
                }
            }
            
            self.subMandaratViewsExceptForCenter.forEach { (key, subMandaratView) in
                
                subMandaratView.alpha = 0
                
                // 랜덤이동
                subMandaratView.moveOneInch(direction: .random)
            }
            
            self.view.backgroundColor = .clear
            
        } completion: { completed in
               
            context.completeTransition(completed)
        }
    }

    
    class PresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.3
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let viewController = transitionContext.viewController(forKey: .to) as? SubMandaratPageViewController else { return }
            
            viewController.onAppearAnimation(
                duration: transitionDuration(using: transitionContext),
                context: transitionContext
            )
        }
    }
    
    class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.2
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let viewController = transitionContext.viewController(forKey: .from) as? SubMandaratPageViewController else { return }
            
            viewController.onDisappearAnimation(
                duration: transitionDuration(using: transitionContext),
                context: transitionContext
            )
        }
    }
}


// MARK: Portrait & Landscape
private extension SubMandaratPageViewController {
    
    enum DeviceMode {
        case portrait, landscape
    }
    
    func fitLayoutTo(mode: DeviceMode) {
        
        switch mode {
        case .portrait:
            
            landscapeConstraints.forEach({ $0.isActive = false })
            portraitConstraints.forEach({ $0.isActive = true })
            
        case .landscape:
            
            portraitConstraints.forEach({ $0.isActive = false })
            landscapeConstraints.forEach({ $0.isActive = true })
            
        }
        
        view.layoutIfNeeded()
    }
}



// MARK: Return button
private extension SubMandaratPageViewController {
    
    func setReturnButtonLayout() {
        
        view.addSubview(returnButton)
        
        returnButton.snp.makeConstraints { make in
            
            portraitConstraints.append(contentsOf: [
                
                make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
                    .inset(10)
                    .priority(.high)
                    .constraint.layoutConstraints.first!,
                make.top.equalTo(subMandaratContainerView.snp.bottom)
                    .inset(-10)
                    .priority(.high)
                    .constraint.layoutConstraints.first!,
            ])
            
            
            landscapeConstraints.append(contentsOf: [
                
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                    .priority(.high)
                    .constraint.layoutConstraints.first!,
                
                make.left.equalTo(subMandaratContainerView.snp.right)
                    .inset(-10)
                    .priority(.high)
                    .constraint.layoutConstraints.first!,
                
                make.right.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.right)
                    .priority(.high)
                    .constraint.layoutConstraints.first!,
            ])
        }
    }
}


// MARK: Toast view
extension SubMandaratPageViewController {
    
    func createCancellableToastView() -> CancellableToastView {
        
        let toastView: CancellableToastView = .init()
        
        view.addSubview(toastView)
        
        toastView.snp.makeConstraints { make in
            
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(20)
        }
        
        return toastView
    }
}
