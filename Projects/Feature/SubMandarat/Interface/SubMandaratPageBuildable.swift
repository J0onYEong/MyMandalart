//
//  SubMandaratPageBuildable.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import SharedPresentationExt

public protocol SubMandaratPageBuildable: Buildable<SubMandaratPageDependency> {
    
    func build() -> SubMandaratPageRoutable
}
