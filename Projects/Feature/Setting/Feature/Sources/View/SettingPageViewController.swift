//
//  SettingPageViewController.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import UIKit

import SharedPresentationExt

import ReactorKit
import RxSwift
import RxCocoa

class SettingPageViewController: UIViewController, View, SettingPageViewControllable {
    
    // Sub view
    private let navigationBarView: NavigationBarView = .init()
    private let settingRowScrollView: UIScrollView = .init()
    
    
    var disposeBag: DisposeBag = .init()
 
    init(reactor: SettingPageViewModel) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    
    private func setUI() {
        
        // view
        view.backgroundColor = .white
        
        
        // navigationBarView
        navigationBarView
            .update("설정 화면")
        
        
        // settingRowScrollView
        settingRowScrollView.backgroundColor = .clear
    }
    
    
    private func setLayout() {
        
        // navigationBarView
        view.addSubview(navigationBarView)
        
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
        }
        
        
        // settingRowScrollView
        view.addSubview(settingRowScrollView)
        
        settingRowScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(navigationBarView.snp.bottom).inset(-20)
        }
    }
    
    
    func bind(reactor: SettingPageViewModel) {
        
        // Bind, self
        self.rx.viewDidLoad
            .map({ _ in Reactor.Action.viewDidLoad  })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind, NavigationBar
        navigationBarView.rx.tap
            .map({ _ in Reactor.Action.backButtonClicked  })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind, RowItemView
        reactor.state
            .map(\.rowItemViewModel)
            .take(2)
            .subscribe(onNext: { [weak self] viewModels in
                        
                self?.createSettingItemRowView(viewModels: viewModels)
            })
            .disposed(by: disposeBag)
        
    }
}


// MARK: Create SettingItemRowView
private extension SettingPageViewController {
    
    func createSettingItemRowView(viewModels: [SettingItemRowViewModel]) {
        
        let subViews: [UIView] = viewModels.enumerated().map { index, viewModel in
            
            SettingItemRowView(reactor: viewModel)
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: subViews)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 1
        stackView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        
        settingRowScrollView.addSubview(stackView)
        
        let contentGuide = settingRowScrollView.contentLayoutGuide
        let frameGuide = settingRowScrollView.frameLayoutGuide
        
        stackView.snp.makeConstraints { make in
            
            make.edges.equalTo(contentGuide.snp.edges)
            make.width.equalTo(frameGuide.snp.width)
        }
    }
}
