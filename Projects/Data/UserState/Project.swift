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
            sources: ["Sources/**"],
            dependencies: [
                .data(interface: .UserState),
            ]
        ),


        // Testing
        .target(
            name: "DataUserStateTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).data.UserState.testing",
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
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
