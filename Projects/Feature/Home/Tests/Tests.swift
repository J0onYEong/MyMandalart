//
//  Tests.swift
//
//

import UIKit
import XCTest

@testable import FeatureHomeTesting
@testable import FeatureHome

@testable import SharedDesignSystem

import DomainMandaratInterface

import ReactorKit
import RxSwift

class HomeFeatureTestCase: XCTestCase {
    
    func test_inputEmptyTitleAndSave() {
        
        // 유효한 문자열이 저장된 상태에서 다시 공백을 입력하고 저장하기를 누른 경우
        
        // Given
        let givenMainMandalart = MainMandaratVO(
            title: "test",
            position: .ONE_ONE,
            colorSetId: MandalartPalette.type1.identifier,
            description: nil,
            imageURL: nil
        )
        let reactor = EditMainMandaratViewModel(
            logger: FakeLogger(),
            mainMandaratVO: givenMainMandalart
        )
        
        // When
        
        // 유저가 빈 문자열을 입력후 저장하기 버튼을 클릭
        reactor.action.onNext(.editTitleText(text: ""))
        reactor.action.onNext(.saveButtonClicked)
        
        
        // Then
        XCTAssertNotNil(reactor.currentState.toastData)
    }
    
    
    func test_inputValidTitleAndSave() {
        
        // 사용자가 유효한 문자열을 입력했을 때 ToastView가 나타나지 않음
        
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
        
        
        // When
        
        // 유저가 유효한 문자열을 입력후 저장하기 버튼을 클릭
        reactor.action.onNext(.editTitleText(text: "test"))
        reactor.action.onNext(.saveButtonClicked)
        
        
        // Then
        XCTAssertNil(reactor.currentState.toastData)
    }
}
