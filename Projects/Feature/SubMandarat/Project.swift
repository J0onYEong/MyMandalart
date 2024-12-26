//
//  Project.swift
//
//  Created by choijunios on 2024/12/26
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "SubMandarat",
    targets: [
        
        // Example
        .target(
            name: "FeatureSubMandaratExample",
            destinations: .iOS,
            product: .app,
            bundleId: "\(Project.Environment.bundlePrefix).feature.SubMandarat.example",
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .SubMandarat),
                .feature(testing: .SubMandarat),
            ]
        ),


        // Tests
        .target(
            name: "FeatureSubMandaratTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).feature.SubMandarat.tests",
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .SubMandarat),
                .feature(testing: .SubMandarat),
            ]
        ),


        // Feature
        .target(
            name: "FeatureSubMandarat",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.SubMandarat",
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                .feature(interface: .SubMandarat),
            ]
        ),


        // Testing
        .target(
            name: "FeatureSubMandaratTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.SubMandarat.testing",
            sources: ["Testing/**"],
            dependencies: [
                .feature(interface: .SubMandarat),
            ]
        ),


        // Interface
        .target(
            name: "FeatureSubMandaratInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.SubMandarat.interface",
            sources: ["Interface/**"],
            dependencies: [
                
                .domain(interface: .Mandarat),
                .shared(interface: .Navigation),
                .shared(interface: .AlertHelper),
                .shared(implements: .PresentationExt),
                .shared(implements: .DesignSystem)
            ]
        ),
    ]
)
