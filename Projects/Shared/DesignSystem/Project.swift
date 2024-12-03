//
//  Project.swift
//
//  Created by choijunios on 2024/12/03
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "DesignSystem",
    targets: [

        // Tests
        .target(
            name: "DomainDesignSystemTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).domain.DesignSystem.tests",
            sources: ["Tests/**"],
            dependencies: [
                .domain(implements: .DesignSystem),
                .domain(testing: .DesignSystem),
            ]
        ),


        // Domain
        .target(
            name: "DomainDesignSystem",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).domain.DesignSystem",
            sources: ["Sources/**"],
            dependencies: [
                .domain(interface: .DesignSystem),
            ]
        ),


        // Testing
        .target(
            name: "DomainDesignSystemTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.DesignSystem.testing",
            sources: ["Testing/**"],
            dependencies: [
                .domain(interface: .DesignSystem),
            ]
        ),


        // Interface
        .target(
            name: "DomainDesignSystemInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.DesignSystem.interface",
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
