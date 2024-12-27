//
//  Project.swift
//
//  Created by choijunios on 2024/12/03
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Mandarat",
    targets: [

        // Tests
        .target(
            name: "DomainMandaratTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).domain.Mandarat.tests",
            sources: ["Tests/**"],
            dependencies: [
                .domain(implements: .Mandarat),
                .domain(testing: .Mandarat),
            ]
        ),


        // Domain
        .target(
            name: "DomainMandarat",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).domain.Mandarat",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                .domain(interface: .Mandarat),
            ]
        ),


        // Testing
        .target(
            name: "DomainMandaratTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.Mandarat.testing",
            sources: ["Testing/**"],
            dependencies: [
                .domain(interface: .Mandarat),
            ]
        ),


        // Interface
        .target(
            name: "DomainMandaratInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.Mandarat.interface",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Interface/**"],
            dependencies: [
                
                .shared(implements: .Core),
                .thirdParty(library: .RxSwift),
            ]
        ),
    ]
)
