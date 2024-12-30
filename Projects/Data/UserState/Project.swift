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
            name: "DataUserStateTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).data.UserState.tests",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .data(implements: .UserState),
                .data(testing: .UserState),
            ]
        ),


        // Data
        .target(
            name: "DataUserState",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).data.UserState",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                .data(interface: .UserState),
            ]
        ),


        // Testing
        .target(
            name: "DataUserStateTesting",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).data.UserState.testing",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Testing/**"],
            dependencies: [
                .data(interface: .UserState),
            ]
        ),


        // Interface
        .target(
            name: "DataUserStateInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).data.UserState.interface",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
