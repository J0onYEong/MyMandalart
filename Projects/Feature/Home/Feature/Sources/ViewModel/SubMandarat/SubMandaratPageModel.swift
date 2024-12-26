//
//  SubMandaratPageModel.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import DomainMandaratInterface
import SharedCore

import ReactorKit
import RxSwift

class SubMandaratPageModel: Reactor, MainMandaratViewModelListener, SubMandaratViewModelListener, EditSubMandaratViewModelDelegate {
    
    // DI
    private let mandaratUseCase: MandaratUseCase
    
    
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
    
    
    
    init(mandaratUseCase: MandaratUseCase, mainMandarat: MainMandaratVO) {

        self.mandaratUseCase = mandaratUseCase
        self.mainMandaratVO = mainMandarat

        
        // 메인 만다라트 뷰모델 생성
        mainMandaratViewModel = .init(position: .TWO_TWO)
        mainMandaratViewModel.delegate = self
        
        
        // 서브 만다라트 뷰모델 생성
        createSubMandaratViewModels()
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .viewDidLoad:
            
            // 사이드 이펙트, 메인만다라트 랜더링 지시
            mainMandaratViewModel.requestRender(.create(from: mainMandaratVO))
            
            
            // 사이드 이펙트, 서브만다라트 데이터 fetch
            mandaratUseCase
                .requestSubMandarats(mainMandarat: mainMandaratVO)
                .asObservable()
                .subscribe(onNext: { [weak self] fetchedSubMandarats in
                    
                    guard let self else { return }
                    
                    // 사이드 이펙트, 서브 만다라트 데이터 홀드
                    fetchedSubMandarats.forEach { subMandarat in
                        
                        let position = subMandarat.position
                        self.subMandarats[position] = subMandarat
                        
                        // Rendering
                        self.render(subMandarat: subMandarat)
                    }
                })
                .disposed(by: disposeBag)
            
            
            return .never()
            
        case .requestEditSubMandarat(let position):
            
            let subMandaratVO = subMandarats[position] ?? .createEmpty(with: position)
            presentEditSubMandaratViewController(subMandaratVO)
            
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
                    position: position,
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
        
//        router.pop(
//            animated: true,
//            delegate: transitionDelegate
//        )
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
        
//        router
//            .present(
//                viewController,
//                animated: true,
//                modalPresentationSytle: .custom
//            )
    }
}


// MARK: EditSubMandaratViewModelDelegate
extension SubMandaratPageModel {
    
    func editFinishedWithSavingRequest(edited subMandarat: SubMandaratVO) {
        
        let position = subMandarat.position
        self.subMandarats[position] = subMandarat
        
        
        // #1. save
        mandaratUseCase.saveSubMandarat(
            mainMandarat: self.mainMandaratVO,
            subMandarat: subMandarat
        )
        
        
        // #2. render
        self.render(subMandarat: subMandarat)
    }
}


// MARK: Private functions
private extension SubMandaratPageModel {
    
    func render(subMandarat: SubMandaratVO) {
        
        let position = subMandarat.position
        
        let primaryColor: UIColor! = .color(mainMandaratVO.hexColor)
        
        subMandaratViewModels[position]?.render(
            object: .create(vo: subMandarat, primaryColor: primaryColor)
        )
    }
}
