//
//  StubMainMandaratVO.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import DomainMandaratInterface

public extension MainMandaratVO {
    
    static let stub: Self = .init(
        title: "테스트",
        position: .ONE_ONE,
        colorSetId: "type1",
        description: "테스트 디스크립션입니다, 테스트 디스크립션입니다, 테스트 디스크립션입니다, 테스트 디스크립션입니다",
        imageURL: nil
    )
}
