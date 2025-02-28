//
//  CreateDailyViewModel.swift
//  CreateDaily
//
//  Created by choijunios on 2/28/25.
//

import Foundation
import Speech

import SharedPresentationExt

import ReactorKit

final class CreateDailyViewModel: Reactor, CreateDailyViewModelable {
    
    var initialState: State
    
    init() {
        self.initialState = .init(
            presentation: .init(
                unauthorizedPage: false
            )
        )
    }
    
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .startSpeechReconizationButtonTapped:
            requestAuthForAudioRecognization()
                .filter({ isAuthorized in !isAuthorized })
                .map({ _ in .presentSpeechDisabledPage })
        default:
            Observable.just(action)
        }
    }
    
    
    func reduce(state: State, mutation: Action) -> State {
        var newState = state
        switch mutation {
        case .checkSpeechReconizationAuthorizationStatus:
            let status = SFSpeechRecognizer.authorizationStatus()
            switch status {
            case .notDetermined, .authorized:
                newState.presentation.unauthorizedPage = false
            default:
                newState.presentation.unauthorizedPage = true
            }
        case .presentSpeechDisabledPage:
            newState.presentation.unauthorizedPage = true
        default:
            return newState
        }
        return newState
    }
    
}


// MARK: Public interface
extension CreateDailyViewModel {
    enum Action {
        case checkSpeechReconizationAuthorizationStatus
        case startSpeechReconizationButtonTapped
        
        // Internal
        case presentSpeechDisabledPage
    }
    struct State {
        var presentation: Presentation
        
        struct Presentation {
            var unauthorizedPage: Bool
        }
    }
}


// MARK: Audio recognization permission
private extension CreateDailyViewModel {
    func requestAuthForAudioRecognization() -> Observable<Bool> {
        let publisher = PublishSubject<Bool>()
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                publisher.onNext(true)
            default:
                publisher.onNext(false)
            }
        }
        return publisher.asObservable()
    }
}
