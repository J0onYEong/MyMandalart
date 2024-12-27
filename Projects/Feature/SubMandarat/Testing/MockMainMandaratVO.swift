//
//  MockMainMandaratVO.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import DomainMandaratInterface

public extension MainMandaratVO {
    
    static let mock: Self = .init(
        title: "테스트",
        position: .ONE_ONE,
        hexColor: "#FFFFFF",
        description: "테스트 디스크립션입니다, 테스트 디스크립션입니다, 테스트 디스크립션입니다, 테스트 디스크립션입니다",
        imageURL: nil
    )
}
