//
//  Tests.swift
//
//

import UIKit
import Testing

@testable import FeatureHomeTesting
@testable import FeatureHome

@testable import SharedDesignSystem

import DomainMandaratInterface

struct EditMainMandaratViewModelTest {
    
    @Test
    func saveMainMandalartValidation() async {
        
        // 사용자가 빈 문자열을 입력했을 때, Toast가 표시되는지 검증한다.
        
        await MainActor.run {
            
            // Given
            let givenMainMandalart = MainMandaratVO(
                title: "",
                position: .ONE_ONE,
                colorSetId: MandalartPalette.type1.identifier,
                description: nil,
                imageURL: nil
            )
            let reactor = EditMainMandaratViewModel(
                logger: FakeLogger(),
                mainMandaratVO: givenMainMandalart
            )
            
            
            let view = EditMainMandaratViewController()
            view.bind(reactor: reactor)
            #expect(view.reactor != nil)
            
            
            // When
            
            // 유저가 빈 문자열을 입력후 저장하기 버튼을 클릭
            view.titleInputView.update("")
            view.saveButton.invokeTap()
            
            
            // Then
            #expect(reactor.currentState.toastData != nil)
        }
    }
}
