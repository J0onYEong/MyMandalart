//
//  Project.swift
//
//  Created by choijunios on 2024/12/07
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Mandarat",
    targets: [

        // Tests
        .target(
            name: "DataMandaratTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).data.Mandarat.tests",
            sources: ["Tests/**"],
            dependencies: [
                .data(implements: .Mandarat),
                .data(testing: .Mandarat),
            ]
        ),


        // Data
        .target(
            name: "DataMandarat",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).data.Mandarat",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                .data(interface: .Mandarat),
            ]
        ),


        // Testing
        .target(
            name: "DataMandaratTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).data.Mandarat.testing",
            sources: ["Testing/**"],
            dependencies: [
                .data(interface: .Mandarat),
            ]
        ),


        // Interface
        .target(
            name: "DataMandaratInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).data.Mandarat.interface",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Interface/**"],
            dependencies: [
                
                .domain(interface: .Mandarat),
                .data(interface: .CoreData),
                .thirdParty(library: .RxSwift),
            ]
        ),
    ]
)
