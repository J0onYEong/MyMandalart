//
//  HomeViewController.swift
//  Home
//
//  Created by choijunios on 12/4/24.
//

import UIKit

import DomainMandaratInterface
import SharedDesignSystem
import SharedPresentationExt

import ReactorKit
import RxCocoa

class MainMandaratPageViewController: UIViewController, MainMandaratPageViewControllable,  View {
    
    // Sub view
    private var mainMandaratViews: [MandaratPosition: MainMandaratView] = [:]
    fileprivate var mainMandaratContainerView: UIStackView!
    
    private var sloganContainer: UIView!
    private let sloganLabel1: UILabel = .init()
    private let sloganLabel2: UILabel = .init()
    
    private let settingButton: ImageButton = .init(imageName: "gearshape.fill")

    // Color picker
    private let selectedColor: PublishSubject<UIColor> = .init()
    private var editingColor: UIColor?
    
    var disposeBag: DisposeBag = .init()
    
    init(reactor: MainMandaratPageViewModel) {
        
        super.init(nibName: nil, bundle: nil)
        
        createMainMandaratViews()
        
        self.reactor = reactor
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    
    private func setUI() {
        
        // view
        view.backgroundColor = .white
        
        
        // sloganLabel1
        sloganLabel1.font = .preferredFont(forTextStyle: .title1)
        sloganLabel1.textAlignment = .left
        sloganLabel1.textColor = .black
        sloganLabel1.numberOfLines = 1
        sloganLabel1.adjustsFontSizeToFitWidth = true
        sloganLabel1.minimumScaleFactor = 0.5
        
        
        // sloganLabel2
        sloganLabel2.font = .preferredFont(forTextStyle: .body)
        sloganLabel2.textAlignment = .left
        sloganLabel2.textColor = .black
        sloganLabel2.numberOfLines = 0
        sloganLabel2.minimumScaleFactor = 0.5
        
        
        // settingButton
        settingButton.setImageColor(.lightGray)
    }
    
    
    
    func bind(reactor: MainMandaratPageViewModel) {
        
        // Bind, self
        self.rx.viewDidLoad
            .map({ _ in Reactor.Action.viewDidLoad })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewDidAppear
            .map({ _ in Reactor.Action.viewDidAppear })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // Bind reactors to MainMandaratViews
        MandaratPosition.allCases.forEach { position in
            
            let mainMandaratReactor = reactor.mainMandaratViewReactors[position]!
            
            mainMandaratViews[position]?.bind(reactor: mainMandaratReactor)
        }
        
        
        // Transition animation
        reactor.state
            .compactMap(\.positionToMoveCenter)
            .subscribe(onNext: { [weak self] position in
                
                guard let self else { return }
                
                focusingMainMandaratCell(selected: position) { completed in
                    
                    if completed {
                        reactor.action.onNext(.moveMandaratToCenterFinished(position))
                    }
                    
                }
                
                dismissSubviews()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.transitionAction)
            .distinctUntilChanged()
            .compactMap({ $0 })
            .subscribe(onNext: { [weak self] transitionAction in
                
                guard let self else { return }
                
                switch transitionAction {
                case .resetMainMandaratPage(let selectedPosition):
                    
                    resetMainMandaratPositions(selected: selectedPosition) { completed in
                        
                        if completed {
                            
                            reactor.sendEvent(.resetMainMandaratPageFinished)
                        }
                    }
                    
                    presentSubViews()
                }
                
            })
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
        
        
        // Bind, slogans
        reactor.state
            .distinctDriver(\.slogan1Text)
            .drive(sloganLabel1.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .distinctDriver(\.slogan2Text)
            .drive(sloganLabel2.rx.text)
            .disposed(by: disposeBag)
        
        
        // Bind, settingButton
        settingButton.rx.tap
            .map({ Reactor.Action.settingPageButtonClicked })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        
        setMainMandaratViewLayout()
        
        setSloganLabelLayout()
        
        
        // settingButton
        view.addSubview(settingButton)
        
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(45)
            
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        
        // 최초 설정 : Portrait
        fitLayoutTo(mode: .portrait)
    }
}

private extension MainMandaratPageViewController {
    
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
        
        self.mainMandaratContainerView = mainMandaratContainerStackView
    }
}

// MARK: MainMandarats
private extension MainMandaratPageViewController {
    
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
    
    
    func makeMainMandaratViewToTop(_ position: MandaratPosition) {
        
        let targetView = mainMandaratViews[position]!
        targetView.superview?.layer.sublayers?.forEach({ $0.zPosition = 0 })
        targetView.layer.zPosition = 1
        
        mainMandaratContainerView.layer.sublayers?.forEach({ $0.zPosition = 0 })
        targetView.superview?.layer.zPosition = 1
    }
}


// MARK: Transiton animations
private extension MainMandaratPageViewController {
    
    func resetMainMandaratPositions(selected position: MandaratPosition, completion: @escaping (Bool) -> ()) {
        
        UIView.animate(withDuration: 0.4, animations: {
            
            self.mainMandaratViews.filter({ key, _ in key != position }).values.forEach { mainMandaratView in
                
                mainMandaratView.alpha = 1
            }
            
            self.mainMandaratViews[position]!.moveToIdentity()
            
        }, completion: completion)
    }
    
    
    func focusingMainMandaratCell(selected position: MandaratPosition, completion: @escaping (Bool) -> ()) {
        
        // 선택된 셀을 최상단으로 이동
        makeMainMandaratViewToTop(position)
        
        
        // 중앙 좌표구하기
        let containerSize = mainMandaratContainerView.bounds
        let middlePosition: CGPoint = .init(
            x: containerSize.width/2,
            y: containerSize.height/2
        )
        
        let selectedMainMandaratView = mainMandaratViews[position]!
        
        let positionFittedToView = mainMandaratContainerView.convert(middlePosition, to: selectedMainMandaratView)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            // 선택된 뷰를 중앙으로 이동
            selectedMainMandaratView.moveCenter(point: positionFittedToView)
            
            // 다른 뷰들은 사라짐
            self.mainMandaratViews
                .filter({ (pos, _) in pos != position })
                .values
                .forEach { mainMandaratView in
                    
                    mainMandaratView.alpha = 0
                }
            
        }, completion: completion)
    }
    
    
    func dismissSubviews() {
        
        UIView.animate(withDuration: 0.35) {
            
            self.sloganContainer.alpha = 0
            
            self.view.subviews.forEach { subView in
                
                if subView is CancellableToastView {
                           
                    subView.alpha = 0
                }
            }
        }
        
    }
    
    
    func presentSubViews() {
        
        UIView.animate(withDuration: 0.35) {
            
            self.sloganContainer.alpha = 1
            
            self.view.subviews.forEach { subView in
                
                if subView is CancellableToastView {
                    
                    subView.alpha = 1
                    
                }
            }
        }
    }
}


// MARK: Portrait & Landscape
private extension MainMandaratPageViewController {
    
    enum DeviceMode {
        case portrait, landscape
    }
    
    func fitLayoutTo(mode: DeviceMode) {
        
        switch mode {
        case .portrait:
            
            mainMandaratContainerView.snp.remakeConstraints { make in
                
                make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                    .priority(.high)
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                    .priority(.high)
                make.height.equalTo(mainMandaratContainerView.snp.width)
                    .priority(.high)
                make.centerY.equalToSuperview()
                    .priority(.high)
            }

            sloganContainer.snp.remakeConstraints { make in
                
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
                
                make.bottom.lessThanOrEqualTo(mainMandaratContainerView.snp.top).inset(10)
                    .priority(.required)
                    
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(10)
                    
                make.right.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.right).inset(10)
                    
            }
            
        case .landscape:
            
            mainMandaratContainerView.snp.remakeConstraints { make in
                
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                    .priority(.required)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                    .priority(.required)
                make.width.equalTo(mainMandaratContainerView.snp.height)
                    .priority(.required)
                make.centerX.equalToSuperview()
                    .priority(.required)
            }
            
            sloganContainer.snp.remakeConstraints { make in
                
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
                    
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
                    
                make.right.lessThanOrEqualTo(mainMandaratContainerView.snp.left)
                    .priority(.required)
                    
            }
        }
        
        view.layoutIfNeeded()
    }
}



// MARK: Toast view
extension MainMandaratPageViewController {
    
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


// MARK: Slogan labels
private extension MainMandaratPageViewController {
    
    func setSloganLabelLayout() {
        
        let stack: UIStackView = .init(arrangedSubviews: [
            sloganLabel1, sloganLabel2
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        view.addSubview(stack)
        
        
        self.sloganContainer = stack
    }
}
