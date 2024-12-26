//
//  HomeViewModel.swift
//  Home
//
//  Created by choijunios on 12/4/24.
//

import UIKit

import SharedDependencyInjector
import SharedNavigationInterface
import DomainMandaratInterface

import ReactorKit

class HomeViewModel: Reactor, MainMandaratViewModelDelegate, EditMainMandaratViewModelDelegate {
    
    @Inject private var router: Router
    
    // 의존성 주입
    private let mandaratUseCase: MandaratUseCase
    
    let initialState: State = .init()
    private let disposeBag: DisposeBag = .init()
    
    // Sub reactors
    private(set) var mainMandaratViewReactors: [MandaratPosition: MainMandaratViewModel] = [:]
    
    
    // View model state
    private var mainMandaratVO: [MandaratPosition: MainMandaratVO] = [:]
    
    
    init(mandaratUseCase: MandaratUseCase) {
        
        self.mandaratUseCase = mandaratUseCase
            
        createMainMandaratReactors()
    }
    
    public func sendEvent(_ action: Action) {
        
        self.action.onNext(action)
    }
    
    func mutate(action: Action) -> Observable<Action> {
        
        switch action {
        case .viewDidLoad:
            
            mandaratUseCase
                .requestMainMandarats()
                .observe(on: MainScheduler.asyncInstance)
                .asObservable()
                .subscribe(onNext: { [weak self] mainMandarats in
                    
                    guard let self else { return }
                    
                    // 메인 만다라트 등록
                    mainMandarats.forEach { mainMandaratVO in
                        
                        self.updateMainMandarat(updated: mainMandaratVO)
                    }
                })
                .disposed(by: disposeBag)
            
            return .never()
            
        case .moveMandaratToCenterFinished(let position):
            
            // 해당 위치의 만다라트의 서브만다라트 뷰컨트롤러 표출
            let mainMandaratVO = mainMandaratVO[position]!
            presentSubMandaratViewController(mainMandaratVO)
            
            return .never()
            
        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .moveMandaratToCenter(let position):
            
            var newState = state
            newState.positionToMoveCenter = position
            
            return newState
            
        case .viewDidAppear:
            
            var newState = state
            
            if let selectedPosition = state.positionToMoveCenter {
                
                newState.viewAction = .replaceMainMandarats(selectedPosition: selectedPosition)
                newState.positionToMoveCenter = nil
            }
            
            return newState
            
        case .resetMainMandaratsFinished:
            
            var newState = state
            newState.viewAction = nil
            
            return newState
            
        default:
            return state
        }
    }
}


extension HomeViewModel {
    
    enum ViewAction: Equatable {
        
        case replaceMainMandarats(selectedPosition: MandaratPosition)
    }
    
    
    enum Action {
        
        // Event
        case viewDidLoad
        case viewDidAppear
        case resetMainMandaratsFinished
        case moveMandaratToCenterFinished(MandaratPosition)
        case moveMandaratToCenter(MandaratPosition)
        
        // Side effect
    }
    
    struct State {
        
        var viewAction: ViewAction?
        var positionToMoveCenter: MandaratPosition?
    }
}


// MARK: Navigations
private extension HomeViewModel {
    
    /// 메인 만다라트 수정 및 생성 화면
    func presentEditMainMandaratViewController(_ mainMandaratVO: MainMandaratVO) {
        
        let viewModel: EditMainMandaratViewModel = .init(mainMandaratVO)
        viewModel.delegate = self
        
        let viewController = EditMainMandaratViewController()
        viewController.bind(reactor: viewModel)
        
        router.present(viewController, animated: true, modalPresentationSytle: .custom)
    }
    
    
    /// 서브 만다라트 화면 표출
    func presentSubMandaratViewController(_ mainMandaratVO: MainMandaratVO) {
        
        let position = mainMandaratVO.position
        
        let viewModel: SubMandaratPageModel = .init(
            mandaratUseCase: mandaratUseCase,
            mainMandarat: mainMandaratVO
        )
        
        let viewController = SubMandaratPageViewController()
        viewController.bind(reactor: viewModel)
        
        router.push(
            viewController,
            animated: true,
            delegate: viewModel.transitionDelegate
        )
    }
}


// MARK: MainMandaratViewModelDelegate
extension HomeViewModel {
    
    func mainMandarat(editButtonClicked position: MandaratPosition) {
        
        let mainMandaratVO = mainMandaratVO[position] ?? .createEmpty(with: position)
        presentEditMainMandaratViewController(mainMandaratVO)
    }
    
    func mainMandarat(detailButtonClicked position: MandaratPosition) {
        
        // 화면전환 애니메이션
        action.onNext(.moveMandaratToCenter(position))
    }
}


// MARK: Create main mandarat reactors
private extension HomeViewModel {
    
    func createMainMandaratReactors() {
        
        // MARK: MainMandaratViewModels
        var mainMandaratReactors: [MandaratPosition: MainMandaratViewModel] = [:]
        
        MandaratPosition.allCases.forEach { position in
            
            let reactor: MainMandaratViewModel = .init(position: position)
            reactor.delegate = self
            mainMandaratReactors[position] = reactor
        }
        
        self.mainMandaratViewReactors = mainMandaratReactors
    }
}


// MARK: EditMainMandaratViewModelDelegate
extension HomeViewModel {
    
    func editFinishedWithSavingRequest(edited mainMandarat: MainMandaratVO) {
        
        mandaratUseCase.saveMainMandarat(mainMandarat: mainMandarat)
        
        self.updateMainMandarat(updated: mainMandarat)
    }
}


// MARK: 만다라트 상태를 상태에 반영
private extension HomeViewModel {
    
    /// HomeViewModel상태 업데이트 및 변경 사항을 MainMandaratViewModel에 전파
    func updateMainMandarat(updated mainMandarat: MainMandaratVO) {
        
        //#1. 사이드이팩트, 상태저장
        mandaratUseCase.saveMainMandarat(mainMandarat: mainMandarat)
        
        
        //#2. 사이드이팩트, HomeViewModel 업데이트
        let position = mainMandarat.position
        self.mainMandaratVO[position] = mainMandarat
        
        
        //#3. 사이드이팩트, 변경 상태를 메인 만다라트 뷰모델에 전달
        let mainMandaratViewModel = mainMandaratViewReactors[position]
        mainMandaratViewModel?.requestRender(.create(from: mainMandarat))
    }
}
