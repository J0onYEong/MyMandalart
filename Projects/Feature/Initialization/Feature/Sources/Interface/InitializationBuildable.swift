//
//  InitializationBuildable.swift
//  Initialization
//
//  Created by choijunios on 12/30/24.
//

import SharedPresentationExt

public protocol InitializationBuildable: Buildable<InitializationDependency> {
    
    func build() -> InitializationRoutable
}
