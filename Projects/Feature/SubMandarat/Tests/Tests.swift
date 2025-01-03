//
//  Tests.swift
//
//

import Foundation

import XCTest

@testable import FeatureSubMandarat
@testable import FeatureSubMandaratTesting

import DomainMandaratInterface

import SharedDesignSystem

class TestCase: XCTestCase {
    
    
    func test_mainMandalartDescriptionViewIsSet() {
        
        // 전달한 메인 만다라트 정보가 올바르게 DescriptionView에 적용되는 지 확인한다.
        
        // Given
        let stubTitle = "stubTitle"
        let stubDescription = "stubDescription"
        
        let reactor = SubMandaratPageViewModel(
            mandaratUseCase: FakeMandaratUseCase(),
            userStateUseCase: FakeUserStateUseCase(),
            logger: FakeLogger(),
            mainMandarat: .init(
                title: stubTitle,
                position: .ONE_ONE,
                colorSetId: MandalartPalette.type1.identifier,
                description: stubDescription,
                imageURL: nil
            )
        )
        
        let presenter = SubMandaratPageViewController(reactor: reactor)
        presenter.bind(reactor: reactor)
        
        // When
        
        
        // Then
        XCTAssertEqual(
            presenter.mainMandaratDescriptionView.titleLabel.text,
            stubTitle
        )
        
        XCTAssertEqual(
            presenter.mainMandaratDescriptionView.descriptionLabel.text,
            stubDescription
        )
    }
}

