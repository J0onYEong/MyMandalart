//
//  MainMandaratBuildable.swift
//  HomeInterface
//
//  Created by choijunios on 12/26/24.
//

import SharedPresentationExt

public protocol MainMandaratBuildable: Buildable<MainMandaratDependency> {
    
    func build() -> MainMandaratRoutable
}
