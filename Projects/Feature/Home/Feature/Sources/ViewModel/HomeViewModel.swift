//
//  HomeViewModel.swift
//  Home
//
//  Created by choijunios on 12/4/24.
//

import UIKit

import DomainMandaratInterface

import ReactorKit

class HomeViewModel: Reactor, MainMandaratViewModelDelegate {
    
    // 의존성 주입
    private let mandaratUseCase: MandaratUseCase
    
    let initialState: State = .init()
    
    // Sub reactors
    private(set) var mainMandaratViewReactors: [MandaratPosition: MainMandaratViewModel] = [:]
    let editMainMandaratReactor: EditMainMandaratViewModel = .init()
    
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
            
            return mandaratUseCase
                .requestMainMandarats()
                .asObservable()
                .map { mainMandarats in
                    
                    Action.fetchedMainMandarat(mainMandarats)
                }
            
        case .addMainMandaratButtonClicked(let position):
            
            return state
                .map(\.mainMandaratVO)
                .map { mandaratVODict in
                    mandaratVODict[position]
                }
                .map { mandaratVO in
                    Action.openEditMainMandaratView(mandaratVO)
                }
            
        default:
            return .just(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        
        switch mutation {
        case .fetchedMainMandarat(let mainMandarats):
            
            var newState = state
            mainMandarats.forEach { mainMandaratVO in
                
                let position = mainMandaratVO.position
                newState.mainMandaratVO[position] = mainMandaratVO
                
            }
            return newState
            
        case .openEditMainMandaratView(let mainMandaratVO):
            
            var newState = state
            newState.presentEditMainMandaratView = true
            editMainMandaratReactor.editWithPreviousData(mainMandaratVO)
            
            return newState
            
        default:
            return state
        }
        
    }
}

extension HomeViewModel {
    
    enum Action {
        
        // Event
        case addMainMandaratButtonClicked(MandaratPosition)
        case viewDidLoad
        
        // Side effect
        case openEditMainMandaratView(MainMandaratVO?)
        case fetchedMainMandarat([MainMandaratVO])
    }
    
    struct State {
    
        var mainMandaratVO: [MandaratPosition: MainMandaratVO] = [:]
        var presentEditMainMandaratView: Bool = false
        
        // Color picker
        var colorPickerPresentModel: ColorPickerPresentModel?
    }
}

// MARK: MainMandaratViewModelDelegate
extension HomeViewModel {
    
    func mainMandarat(buttonClicked position: MandaratPosition) {
        
        self.action.onNext(.addMainMandaratButtonClicked(position))
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
