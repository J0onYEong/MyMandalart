//
//  HomeViewModel.swift
//  Home
//
//  Created by choijunios on 12/4/24.
//

import UIKit

import FeatureSubMandarat
import SharedPresentationExt
import DomainMandaratInterface

import ReactorKit


class MainMandaratPageViewModel: Reactor, MainMandaratPageViewModelable, MainMandaratViewModelListener, EditMainMandaratViewModelDelegate, SubMandaratPageViewModelListener {
    

    // 의존성 주입
    private let mandaratUseCase: MandaratUseCase
    
    
    // Coordinator
    weak var router: MainMandaratPageRouting!
    
    
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


extension MainMandaratPageViewModel {
    
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
private extension MainMandaratPageViewModel {
    
    /// 메인 만다라트 수정 및 생성 화면
    func presentEditMainMandaratViewController(_ mainMandaratVO: MainMandaratVO) {
        
        router.presentEditMainMandaratPage(mainMandarat: mainMandaratVO)
    }
    
    
    /// 서브 만다라트 화면 표출
    func presentSubMandaratViewController(_ mainMandaratVO: MainMandaratVO) {
        
        router.presentSubMandaratPage(mainMandarat: mainMandaratVO)
    }
}


// MARK: MainMandaratViewModelDelegate
extension MainMandaratPageViewModel {
    
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
private extension MainMandaratPageViewModel {
    
    func createMainMandaratReactors() {
        
        // MARK: MainMandaratViewModels
        var mainMandaratReactors: [MandaratPosition: MainMandaratViewModel] = [:]
        
        MandaratPosition.allCases.forEach { position in
            
            let reactor: MainMandaratViewModel = .init(position: position)
            reactor.listener = self
            mainMandaratReactors[position] = reactor
        }
        
        self.mainMandaratViewReactors = mainMandaratReactors
    }
}


// MARK: EditMainMandaratViewModelDelegate
extension MainMandaratPageViewModel {
    
    func editFinishedWithSavingRequest(edited mainMandarat: MainMandaratVO) {
        
        mandaratUseCase.saveMainMandarat(mainMandarat: mainMandarat)
        
        self.updateMainMandarat(updated: mainMandarat)
    }
}


// MARK: 만다라트 상태를 상태에 반영
private extension MainMandaratPageViewModel {
    
    /// HomeViewModel상태 업데이트 및 변경 사항을 MainMandaratViewModel에 전파
    func updateMainMandarat(updated mainMandarat: MainMandaratVO) {
        
        //#1. 사이드이팩트, HomeViewModel 업데이트
        let position = mainMandarat.position
        self.mainMandaratVO[position] = mainMandarat
        
        
        //#2. 사이드이팩트, 변경 상태를 메인 만다라트 뷰모델에 전달
        let mainMandaratViewModel = mainMandaratViewReactors[position]
        mainMandaratViewModel?.requestRender(.create(from: mainMandarat))
    }
}


// MARK: SubMandaratPageViewModelListener
extension MainMandaratPageViewModel {
    
    func subMandaratPageFinished() {
        
        router.dismissSubMandaratPage()
    }
}
