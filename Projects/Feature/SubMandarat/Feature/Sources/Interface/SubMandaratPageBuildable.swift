//
//  SubMandaratPageBuildable.swift
//  SubMandarat
//
//  Created by choijunios on 12/27/24.
//

import DomainMandaratInterface
import SharedPresentationExt

public protocol SubMandaratPageBuildable: Buildable<SubMandaratPageDependency> {
    
    func build(mainMandaratVO: MainMandaratVO) -> SubMandaratPageRoutable
}
