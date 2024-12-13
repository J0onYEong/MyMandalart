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
                .asObservable()
                .withUnretained(self)
                .subscribe(onNext: { viewModel, mainMandarats in
                    
                    mainMandarats.forEach { mainMandaratVO in
                        
                        viewModel.updateMainMandarat(updated: mainMandaratVO)
                    }
                })
                .disposed(by: disposeBag)
            
            return .never()
        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        default:
            return state
        }
    }
}


extension HomeViewModel {
    
    enum Action {
        
        // Event
        case mandaratUpdated(MainMandaratVO)
        case viewDidLoad
        
        // Side effect
    }
    
    struct State {
    
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
    
    func presentSubMandaratViewController(_ mainMandaratVO: MainMandaratVO) {
        
        let viewController = SubMandaratViewController()
        router.present(viewController, animated: true, modalPresentationSytle: .custom)
    }
}


// MARK: MainMandaratViewModelDelegate
extension HomeViewModel {
    
    func mainMandarat(editButtonClicked position: MandaratPosition) {
        
        let mainMandaratVO = mainMandaratVO[position] ?? .createEmpty(with: position)
        presentEditMainMandaratViewController(mainMandaratVO)
    }
    
    func mainMandarat(detailButtonClicked position: MandaratPosition) {
        
        let mainMandaratVO = mainMandaratVO[position]!
        presentSubMandaratViewController(mainMandaratVO)
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
        
        action.onNext(.mandaratUpdated(mainMandarat))
        
        mandaratUseCase.saveMainMandarat(mainMandarat: mainMandarat)
        
        self.updateMainMandarat(updated: mainMandarat)
    }
}


// MARK: 만다라트 상태를 상태에 반영
private extension HomeViewModel {
    
    /// HomeViewModel상태 업데이트 및 변경 사항을 MainMandaratViewModel에 전파
    func updateMainMandarat(updated mainMandarat: MainMandaratVO) {
        
        //#1. HomeViewModel 업데이트
        let position = mainMandarat.position
        self.mainMandaratVO[position] = mainMandarat
        
        
        //#2. 변경 상태를 메인 만다라트 뷰모델에 전달
        let mainMandaratViewModel = mainMandaratViewReactors[position]
        mainMandaratViewModel?.requestRender(.create(from: mainMandarat))
    }
}
