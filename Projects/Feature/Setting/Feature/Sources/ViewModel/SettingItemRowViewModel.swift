//
//  SettingItemRowViewModel.swift
//  Setting
//
//  Created by choijunios on 12/31/24.
//

import ReactorKit

enum SettingItemRowType: Int, CaseIterable {
    
    case editNickName
    case personalDataPolicy
    case contactToDeveloper
    
    public var rowTitleText: String {
        switch self {
        case .editNickName:
            "닉네임 변경"
        case .personalDataPolicy:
            "개인정보 처리 방침"
        case .contactToDeveloper:
            "개발자와 소통하기"
        }
    }
    
    public static var rowOrder: [Self] {
        
        Self.allCases.sorted {
            $0.rawValue < $1.rawValue
        }
    }
}


protocol SettingItemRowViewModelListener: AnyObject {
    
    func presentNickNameEditPage()
}


class SettingItemRowViewModel: Reactor {
    
    // Listener
    weak var listener: SettingItemRowViewModelListener?
    

    var initialState: State

    
    private let settingRowType: SettingItemRowType
    
    
    init(type: SettingItemRowType) {
        
        self.settingRowType = type
        
        self.initialState = .init(
            title: type.rowTitleText
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapSettingRow:
            
            switch settingRowType {
            case .personalDataPolicy:
                
                handlePeronalDataPolicyRequest()
                
            case .editNickName:
                
                handleEditNickNameRequest()
                
            case .contactToDeveloper:
                
                handleContactToDevRequest()
            }
        }
        
        return .never()
    }

}


// MARK: Reactor
extension SettingItemRowViewModel {
    
    enum Action {
        case tapSettingRow
    }
    
    struct State {
        var title: String
    }
}


// MARK: 개인정보 처리 방침
extension SettingItemRowViewModel {
    
    func handlePeronalDataPolicyRequest() {
        
        
    }
}


// MARK: 닉네임 변경하기
extension SettingItemRowViewModel {
    
    
    func handleEditNickNameRequest() {
        
        listener?.presentNickNameEditPage()
    }
}


// MARK: 개발자와 소통하기
extension SettingItemRowViewModel {
    
    func handleContactToDevRequest() {
        
        
    }
}
