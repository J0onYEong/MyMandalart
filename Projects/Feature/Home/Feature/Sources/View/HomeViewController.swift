//
//  HomeViewController.swift
//  Home
//
//  Created by choijunios on 12/4/24.
//

import UIKit

import DomainMandaratInterface

import ReactorKit
import RxCocoa

class HomeViewController: UIViewController, View {
    
    // Sub view
    private var mainMandaratViews: [MandaratPosition: MainMandaratView] = [:]
    private let editMandaratView: EditMainMandaratView = .init()
    
    
    var disposeBag: DisposeBag = .init()
    
    init(reactor: HomeViewModel) {
        
        super.init(nibName: nil, bundle: nil)
        
        createMainMandaratViews()
        
        self.reactor = reactor
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setLayout()
        
        reactor?.sendEvent(.viewDidLoad)
        
        subscribeToKeyboardEvent()
    }
    
    
    func bind(reactor: HomeViewModel) {
        
        // Bind edit main mandarat view
        editMandaratView.bind(reactor: reactor.editMainMandaratReactor)
        
        
        // Bind reactors to MainMandaratViews
        MandaratPosition.allCases.forEach { position in
            
            let mainMandaratReactor = reactor.mainMandaratViewReactors[position]!
            
            mainMandaratViews[position]?.bind(reactor: mainMandaratReactor)
        }
        
        
        // Bind HomeViewModel
        reactor.state
            .map(\.presentEditMainMandaratView)
            .withUnretained(self)
            .subscribe(onNext: { vc, isPresent in
                
                vc.editMandaratView.isHidden = !isPresent
                
                if isPresent {
                    
                    vc.editMandaratView.onAppearTask()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        
        setMainMandaratViewLayout()
        
        setEditMandaratViewLayout()
    }
}

private extension HomeViewController {
    
    func setMainMandaratViewLayout() {
        
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
                arrangedSubviews: getMainMandaratViews(rowItems)
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
    }
    
    func setEditMandaratViewLayout() {
        
        view.addSubview(editMandaratView)
        editMandaratView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
}

// MARK: MainMandarats
private extension HomeViewController {
    
    func createMainMandaratViews() {
        
        MandaratPosition.allCases.forEach { mandaratPosition in
            let view = MainMandaratView()
            self.mainMandaratViews[mandaratPosition] = view
        }
    }
    
    func getMainMandaratViews(_ positions: [MandaratPosition]) -> [MainMandaratView] {
        
        return positions.map { position in
            
            self.mainMandaratViews[position]!
        }
    }
}

private extension HomeViewController {
    
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
                    
                    vc.editMandaratView.snp.updateConstraints { make in
                        
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
                    
                    vc.editMandaratView.snp.updateConstraints { make in
                        
                        make.bottom.equalToSuperview()
                    }
                    
                    vc.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}
