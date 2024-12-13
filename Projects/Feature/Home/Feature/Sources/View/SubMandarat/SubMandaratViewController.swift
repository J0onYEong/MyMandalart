//
//  SubMandaratViewController.swift
//  Home
//
//  Created by choijunios on 12/11/24.
//

import UIKit

import DomainMandaratInterface

import ReactorKit
import RxSwift
import RxCocoa

class SubMandaratViewController: UIViewController {
    
    // Sub view
    fileprivate var subMandaratViews: [MandaratPosition: SubMandaratView] = [:]
    fileprivate var subMandaratContainerView: UIStackView?
    
    private let transitionDelegate: TransitionDelegate = .init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        createSubMandaratViews()
        
        self.transitioningDelegate = transitionDelegate
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayer()
        setLayout()
    }
    
    private func setLayer() {
        
        view.backgroundColor = .clear
    }
    
    
    private func setLayout() {
        
        setSubMandaratViewLayout()
    }
}

// MARK: Sub mandarat views
private extension SubMandaratViewController {
    
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
            
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            
            // width == height
            make.height.equalTo(mainMandaratContainerStackView.snp.width)
            
            // y position
            make.centerY.equalToSuperview()
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


extension SubMandaratViewController {
    
    func onAppearAnimation(duration: CFTimeInterval, context: UIViewControllerContextTransitioning) {
        
        // addSubView
        context.containerView.addSubview(self.view)
        
        
        
        // 모든 셀을 가운데 모으고 투명화한다.
        view.layoutIfNeeded()
        
        subMandaratViews.forEach { (key, subMandaratView) in
            
            subMandaratView.alpha = 0
            
            // 목표좌표를 각뷰의 좌표로 변환
            subMandaratView.moveOneInch(direction: .random)
        }
        
        
        // 동시에 모든 셀을 사방으로 보낸다. + Animation
        UIView.animate(withDuration: duration) {
            
            self.subMandaratViews.values.forEach { subMandaratView in
                
                subMandaratView.moveToIdentity()
                subMandaratView.alpha = 1
            }
        } completion: { completed in
            
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
            return 0.3
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let viewController = transitionContext.viewController(forKey: .to) as? SubMandaratViewController else { return }
            
            viewController.onAppearAnimation(
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
            guard let viewController = transitionContext.viewController(forKey: .from) as? SubMandaratViewController else { return }
            
            
        }
    }
}


