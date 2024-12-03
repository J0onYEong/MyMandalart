//
//  Project.swift
//
//  Created by choijunios on 2024/12/03
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Util",
    targets: [

        // Tests
        .target(
            name: "DomainUtilTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).domain.Util.tests",
            sources: ["Tests/**"],
            dependencies: [
                .domain(implements: .Util),
                .domain(testing: .Util),
            ]
        ),


        // Domain
        .target(
            name: "DomainUtil",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).domain.Util",
            sources: ["Sources/**"],
            dependencies: [
                .domain(interface: .Util),
            ]
        ),


        // Testing
        .target(
            name: "DomainUtilTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.Util.testing",
            sources: ["Testing/**"],
            dependencies: [
                .domain(interface: .Util),
            ]
        ),


        // Interface
        .target(
            name: "DomainUtilInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.Util.interface",
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
