//
//  CreateDailyViewController.swift
//  CreateDaily
//
//  Created by choijunios on 2/28/25.
//

import UIKit

import SharedDesignSystem
import SharedPresentationExt

import ReactorKit
import SnapKit

final class CreateDailyViewController: BaseViewController, View, CreateDailyViewControllable {
    // Views
    private let startSpeechRecognizationButton = IconButton(style: .init(size: .flexible))
    private let audioAuthorizationFailedView = AudioAuthorizationFailedView()
    
    var disposeBag: DisposeBag = .init()
    
    init(reactor: CreateDailyViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    
    func bind(reactor: CreateDailyViewModel) {
        setupOutput(reactor: reactor)
        setupInput(reactor: reactor)
    }
}


// MARK: Setup
private extension CreateDailyViewController {
    func setupUI() {
        // startAudioRecognizationButton
        startSpeechRecognizationButton
            .update(image: UIImage(systemName: "waveform"))
            .update(tintColor: .cyan.withAlphaComponent(0.75))
        view.addSubview(startSpeechRecognizationButton)
        
        
        // audioAuthorizationFailedView
        view.addSubview(audioAuthorizationFailedView)
    }
    
    func setupLayout() {
        // startAudioRecognizationButton
        startSpeechRecognizationButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(75)
        }
        
        
        // audioAuthorizationFailedView
        audioAuthorizationFailedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupInput(reactor: Reactor) {
        // startAudioRecognizationButton
        startSpeechRecognizationButton.tap
            .map({ _ in .startSpeechReconizationButtonTapped })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Life cycle
        lifeCycleEvent
            .filter({ $0 == .viewDidLoad })
            .map({ _ in .viewDidLoad })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func setupOutput(reactor: Reactor) {
        
        // 음성인식 불가화면
        reactor.state
            .map(\.isSpeechDisabledPagePresented)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isPresented in
                guard let self else { return }
                audioAuthorizationFailedView.isHidden = !isPresented
            })
            .disposed(by: disposeBag)
    }
}
