//
//  SubMandaratPageModel.swift
//  Home
//
//  Created by choijunios on 12/13/24.
//

import UIKit

import SharedDesignSystem
import SharedLoggerInterface
import SharedCore

import DomainMandaratInterface
import DomainUserStateInterface

import ReactorKit
import RxSwift

class SubMandaratPageViewModel: Reactor,  SubMandaratViewModelListener, EditSubMandaratViewModelListener, SubMandaratPageViewModelable {
    
    // DI
    private let mandaratUseCase: MandaratUseCase
    private let userStateUseCase: UserStateUseCase
    private let logger: Logger
    
    
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
    
    
    init(mandaratUseCase: MandaratUseCase, userStateUseCase: UserStateUseCase, logger: Logger, mainMandarat: MainMandaratVO) {

        self.mandaratUseCase = mandaratUseCase
        self.userStateUseCase = userStateUseCase
        self.logger = logger
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
                
                let palette = MandalartPalette(identifier: mainMandaratVO.colorSetId)
                
                let viewModel: SubMandaratViewModel = .init(
                    position: position,
                    palette: palette
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
        
        
        // MARK: Logging
        
        // 서브 만다라트 최초 작성
        if !userStateUseCase.checkState(.log_initial_sub_mandalart_creation) {
            
            logInitialSubMandalartCreation(id: subMandarat.id)
            
            userStateUseCase.toggleState(.log_initial_sub_mandalart_creation)
        }
        
        
        // 서브 만다라트 저장
        let subMandalartCount = self.subMandarats.values.count
        
        logSaveSubMandalart(
            mainMandalartId: self.mainMandaratVO.id,
            subMandalartVO: subMandarat,
            subMandalartCount: subMandalartCount
        )
    }
}


// MARK: Private functions
private extension SubMandaratPageViewModel {
    
    func render(subMandarat: SubMandaratVO) {
        
        let position = subMandarat.position
    
        subMandaratViewModels[position]?.render(
            title: subMandarat.title,
            acheivementRate: subMandarat.acheivementRate
        )
    }
}


// MARK: Oboarding toast
private extension SubMandaratPageViewModel {
    
    func checkAndPublishOnboardingData() -> Observable<Action> {
        
        if userStateUseCase.checkState(.onboarding_exit_submandarat_page) == false {
            
            let toastData: CancellableToastData = .init(
                title: "서브 만다라트화면에서 나가는법!",
                description: "돌아가기 버튼 혹은 중앙의 메인 주제 버튼을 눌러주세요.",
                backgroudColor: .lightGray
            )
            
            userStateUseCase.toggleState(.onboarding_exit_submandarat_page)
            
            return .just(.presentCacellableToast(toastData))
        }
        
        return .never()
    }
}


// MARK: Logging
private extension SubMandaratPageViewModel {
    
    func logInitialSubMandalartCreation(id: String) {
        
        let builder = DefaultLogObjectBuilder(eventType: "make_first_sub_mandalart")
            .setProperty(key: "sub_mandalart_id", value: id)
        
        let object = builder.build()
        
        logger.send(object)
    }
    
    
    func logSaveSubMandalart(
        mainMandalartId: String,
        subMandalartVO: SubMandaratVO,
        subMandalartCount: Int
    ) {
        
        let builder = SaveSubMandalartLogBuilder(
            mainMandalartId: mainMandalartId,
            subMandalartId: subMandalartVO.id,
            title: subMandalartVO.title,
            acheivementRate: subMandalartVO.acheivementRate,
            position: subMandalartVO.position,
            subMandalartCount: subMandalartCount
        )
        
        let object = builder.build()
        
        logger.send(object)
    }
}
