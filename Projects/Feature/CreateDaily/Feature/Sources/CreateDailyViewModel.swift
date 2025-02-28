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
        self.initialState = .init(isSpeechDisabledPagePresented: false)
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
        case .viewDidLoad:
            let status = SFSpeechRecognizer.authorizationStatus()
            var presentSpeechPage: Bool!
            switch status {
            case .notDetermined, .authorized:
                presentSpeechPage = true
            default:
                presentSpeechPage = false
            }
            newState.isSpeechDisabledPagePresented = !presentSpeechPage
        case .presentSpeechDisabledPage:
            newState.isSpeechDisabledPagePresented = true
        default:
            return newState
        }
        return newState
    }
    
}


// MARK: Public interface
extension CreateDailyViewModel {
    enum Action {
        case viewDidLoad
        case startSpeechReconizationButtonTapped
        
        // Internal
        case presentSpeechDisabledPage
    }
    struct State {
        var isSpeechDisabledPagePresented: Bool
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
