//
//  Tests.swift
//
//

import UIKit

@testable import FeatureHomeTesting
@testable import FeatureHome

import Testing


struct EditMainMandaratViewModelTest {
    
    @Test
    func saveValidation() {
        
        let editViewModel = EditMainMandaratViewModel(.createEmpty(with: .ONE_ONE))
        
        let testState: EditMainMandaratViewModel.State = .init(
            titleText: "",
            descriptionText: "",
            mandaratTitleColor: .white
        )
        
        // 타이틀 문자열이 비어있는 상태에서 세이브 버튼 클릭
        let resultState = editViewModel.reduce(state: testState, mutation: .saveButtonClicked)
        
        #expect(resultState.alertData != nil)
    }
}
