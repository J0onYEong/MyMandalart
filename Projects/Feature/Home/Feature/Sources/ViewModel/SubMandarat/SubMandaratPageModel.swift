//
//  SubMandaratPageModel.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import SharedNavigationInterface
import DomainMandaratInterface
import SharedDependencyInjector

import ReactorKit
import RxSwift

class SubMandaratPageModel: Reactor, MainMandaratViewModelDelegate, SubMandaratViewModelDelegate, EditSubMandaratViewModelDelegate {
    
    // DI
    @Inject private var router: Router
    
    
    // State for view model
    private let mainMandaratVO: MainMandaratVO
    
    
    // State for view
    var initialState: State = .init()
    
    
    // State for viewModel
    private var subMandarats: [MandaratPosition : SubMandaratVO] = [:]
    
    
    // Sub ViewModel
    let mainMandaratViewModel: MainMandaratViewModel
    private(set) var subMandaratViewModels: [MandaratPosition: SubMandaratViewModel] = [:]
    
    
    // Navigation
    let transitionDelegate: SubMandaratViewControllerTransitionDelegate = .init()
    
    
    private let disposeBag: DisposeBag = .init()
    
    
    
    init(mainMandarat: MainMandaratVO, subMandarats: [SubMandaratVO]) {
        
        self.mainMandaratVO = mainMandarat
        
        
        // 서브 만다라트 데이터를 뷰모델이 보유
        for subMandarat in subMandarats {
            self.subMandarats[subMandarat.position] = subMandarat
        }
        
        
        // 메인 만다라트 뷰모델 생성
        mainMandaratViewModel = .init(position: .TWO_TWO)
        mainMandaratViewModel.delegate = self
        
        
        // 서브 만다라트 뷰모델 생성
        createSubMandaratViewModels()
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .viewDidLoad:
            
            mainMandaratViewModel.requestRender(.create(from: mainMandaratVO))
            
            return .just(action)
            
        case .requestEditSubMandarat(let position):
            
            let subMandaratVO = subMandarats[position]!
            presentEditSubMandaratViewController(subMandaratVO)
            
            return .never()
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        switch mutation {
        default:
            return state
        }
    }
}

// MARK: Action & State
extension SubMandaratPageModel {
    
    enum Action {
        case viewDidLoad
        case requestEditSubMandarat(MandaratPosition)
    }
    
    struct State {
        
    }
}

private extension SubMandaratPageModel {
    
    func createSubMandaratViewModels() {
        
        MandaratPosition.allCases.filter({ $0 != .TWO_TWO })
            .forEach { position in
                
                let viewModel: SubMandaratViewModel = .init(
                    position: mainMandaratVO.position,
                    color: .color(mainMandaratVO.hexColor) ?? .white
                )
                viewModel.deleate = self
                
                self.subMandaratViewModels[position] = viewModel
            }
    }
}


// MARK: MainMandaratViewModelDelegate
extension SubMandaratPageModel {
    
    func mainMandarat(detailButtonClicked position: MandaratPosition) {
        
        router.pop(
            animated: true,
            delegate: transitionDelegate
        )
    }
}


// MARK: SubMandaratViewModelDelegate
extension SubMandaratPageModel {
    
    func subMandarat(edit position: MandaratPosition) {
        
        self.action.onNext(.requestEditSubMandarat(position))
    }
}


// MARK: Navigation
private extension SubMandaratPageModel {
    
    func presentEditSubMandaratViewController(_ subMandaratVO: SubMandaratVO) {
        
        let viewModel: EditSubMandartViewModel = .init(subMandaratVO)
        viewModel.delegate = self
        
        let viewController: EditSubMandaratViewController = .init()
        viewController.bind(reactor: viewModel)
        
        router
            .present(
                viewController,
                animated: true,
                modalPresentationSytle: .custom
            )
    }
}


// MARK: EditSubMandaratViewModelDelegate
extension SubMandaratPageModel {
    
    func editFinishedWithSavingRequest(edited subMandarat: SubMandaratVO) {
        
        print(subMandarat)
    }
}
