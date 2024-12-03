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
            name: "DataCoreDataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).data.CoreData.tests",
            sources: ["Tests/**"],
            dependencies: [
                .data(implements: .CoreData),
                .data(testing: .CoreData),
            ]
        ),


        // Data
        .target(
            name: "DataCoreData",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).data.CoreData",
            sources: ["Sources/**"],
            dependencies: [
                .data(interface: .CoreData),
            ]
        ),


        // Testing
        .target(
            name: "DataCoreDataTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).data.CoreData.testing",
            sources: ["Testing/**"],
            dependencies: [
                .data(interface: .CoreData),
            ]
        ),


        // Interface
        .target(
            name: "DataCoreDataInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).data.CoreData.interface",
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
