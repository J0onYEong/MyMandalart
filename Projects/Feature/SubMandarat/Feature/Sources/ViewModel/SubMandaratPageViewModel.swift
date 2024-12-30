//
//  SubMandaratPageModel.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import DomainMandaratInterface
import DataUserStateInterface
import SharedCore

import ReactorKit
import RxSwift

class SubMandaratPageViewModel: Reactor,  SubMandaratViewModelListener, EditSubMandaratViewModelListener, SubMandaratPageViewModelable {
    
    // DI
    private let mandaratUseCase: MandaratUseCase
    private let userStateRepository: UserStateRepository
    
    
    // Listener
    weak var listener: SubMandaratPageViewModelListener?
    
    
    // Router
    weak var router: SubMandaratPageRouting!
    
    
    // State for view model
    private let mainMandaratVO: MainMandaratVO
    
    
    // State for view
    var initialState: State
    
    
    // State for viewModel
    private var subMandarats: [MandaratPosition : SubMandaratVO] = [:]
    
    
    // Sub ViewModel
    private(set) var subMandaratViewModels: [MandaratPosition: SubMandaratViewModel] = [:]
    
    
    
    private let disposeBag: DisposeBag = .init()
    
    
    init(mandaratUseCase: MandaratUseCase, userStateRepository: UserStateRepository, mainMandarat: MainMandaratVO) {

        self.mandaratUseCase = mandaratUseCase
        self.userStateRepository = userStateRepository
        self.mainMandaratVO = mainMandarat
        
        self.initialState = .init(
            centerMandarat: mainMandaratVO
        )
        
        // 서브 만다라트 뷰모델 생성
        createSubMandaratViewModels()
    }
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .viewDidLoad:
            
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
            
        case .viewDidAppear:
            
            return checkAndPublishOnboardingData()
            
        case .requestEditSubMandarat(let position):
            
            let subMandaratVO = subMandarats[position] ?? .createEmpty(with: position)
            presentEditSubMandaratViewController(subMandaratVO)
            
            return .never()
            
        case .centerMandaratClicked, .returnButtonClicked:
            
            listener?.subMandaratPageFinished()
            
            return .never()
            
        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        switch mutation {
        case .presentCacellableToast(let toastData):
            
            var newState = state
            newState.cancellableToastData = toastData
            
            return newState
            
        default:
            return state
        }
    }
}

// MARK: Action & State
extension SubMandaratPageViewModel {
    
    enum Action {
        case viewDidLoad
        case viewDidAppear
        case requestEditSubMandarat(MandaratPosition)
        case centerMandaratClicked
        case returnButtonClicked
        case presentCacellableToast(CancellableToastData)
    }
    
    struct State {
        let centerMandarat: MainMandaratVO
        var cancellableToastData: CancellableToastData?
        
        var pageTitle: String {
            centerMandarat.title
        }
        
        var pageDescription: String {
            
            let emptyText = "이건 어떤 만다라트 인가요? 🤔"
            
            if let description = centerMandarat.description, !description.isEmpty {
                
                return description
            }
            
            return emptyText
        }
    }
    
    struct CancellableToastData: Equatable {
        
        let id: String = UUID().uuidString
        let title: String
        let description: String?
        let backgroudColor: UIColor
    }
}

private extension SubMandaratPageViewModel {
    
    func createSubMandaratViewModels() {
        
        MandaratPosition.allCases.filter({ $0 != .TWO_TWO })
            .forEach { position in
                
                let viewModel: SubMandaratViewModel = .init(
                    position: position,
                    color: .color(mainMandaratVO.hexColor) ?? .white
                )
                viewModel.listener = self
                
                self.subMandaratViewModels[position] = viewModel
            }
    }
}


// MARK: SubMandaratViewModelDelegate
extension SubMandaratPageViewModel {
    
    func subMandarat(edit position: MandaratPosition) {
        
        self.action.onNext(.requestEditSubMandarat(position))
    }
}


// MARK: Navigation
private extension SubMandaratPageViewModel {
    
    func presentEditSubMandaratViewController(_ subMandaratVO: SubMandaratVO) {
        
        router.presentEditSubMandaratPage(subMandaratVO: subMandaratVO)
    }
}


// MARK: EditSubMandaratViewModelListener
extension SubMandaratPageViewModel {
    
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
private extension SubMandaratPageViewModel {
    
    func render(subMandarat: SubMandaratVO) {
        
        let position = subMandarat.position
        
        let primaryColor: UIColor! = .color(mainMandaratVO.hexColor)
        
        subMandaratViewModels[position]?.render(
            object: .create(vo: subMandarat, primaryColor: primaryColor)
        )
    }
}


// MARK: Oboarding toast
private extension SubMandaratPageViewModel {
    
    func checkAndPublishOnboardingData() -> Observable<Action> {
        
        if userStateRepository[.onboarding_exit_submandarat_page] == false {
            
            let toastData: CancellableToastData = .init(
                title: "서브 만다라트화면에서 나가는법!",
                description: "돌아가기 버튼 혹은 중앙의 메인 주제 버튼을 눌러주세요.",
                backgroudColor: .lightGray
            )
            
            userStateRepository[.onboarding_exit_submandarat_page] = true
            
            return .just(.presentCacellableToast(toastData))
        }
        
        return .never()
    }
}
