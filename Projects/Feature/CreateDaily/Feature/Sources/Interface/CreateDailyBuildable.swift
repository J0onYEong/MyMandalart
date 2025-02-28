//
//  CreateDailyBuildable.swift
//  Home
//
//  Created by choijunios on 2/28/25.
//

import SharedPresentationExt

public protocol CreateDailyBuildable: Buildable<CreateDailyDependency> {
    
    func build() -> CreateDailyRoutable
}
