//
//  Project.swift
//
//  Created by choijunios on 2024/12/30
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "UserState",
    targets: [

        // Tests
        .target(
            name: "DomainUserStateTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).domain.UserState.tests",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .domain(implements: .UserState),
                .domain(testing: .UserState),
            ]
        ),


        // Domain
        .target(
            name: "DomainUserState",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).domain.UserState",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                .domain(interface: .UserState),
            ]
        ),


        // Testing
        .target(
            name: "DomainUserStateTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.UserState.testing",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Testing/**"],
            dependencies: [
                .domain(interface: .UserState),
            ]
        ),


        // Interface
        .target(
            name: "DomainUserStateInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).domain.UserState.interface",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
