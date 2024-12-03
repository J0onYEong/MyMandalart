//
//  Project.swift
//
//  Created by choijunios on 2024/12/03
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "CoreData",
    targets: [

        // Tests
        .target(
            name: "DomainCoreDataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).domain.CoreData.tests",
            sources: ["Tests/**"],
            dependencies: [
                .domain(implements: .CoreData),
                .domain(testing: .CoreData),
            ]
        ),


        // Domain
        .target(
            name: "DomainCoreData",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).domain.CoreData",
            sources: ["Sources/**"],
            dependencies: [
                .domain(interface: .CoreData),
            ]
        ),


        // Testing
        .target(
            name: "DomainCoreDataTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.CoreData.testing",
            sources: ["Testing/**"],
            dependencies: [
                .domain(interface: .CoreData),
            ]
        ),


        // Interface
        .target(
            name: "DomainCoreDataInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.CoreData.interface",
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
