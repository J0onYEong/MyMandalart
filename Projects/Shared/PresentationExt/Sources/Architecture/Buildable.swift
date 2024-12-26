//
//  Buildable.swift
//  SharedPresentationExt
//
//  Created by choijunios on 12/26/24.
//

open class Buildable<Dependency> {
    
    public let dependency: Dependency
    
    public init(dependency: Dependency) {
        self.dependency = dependency
    }
}
