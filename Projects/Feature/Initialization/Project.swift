//
//  Project.swift
//
//  Created by choijunios on 2024/12/30
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Initialization",
    targets: [
        
        // Example
        .target(
            name: "FeatureInitializationExample",
            destinations: .iOS,
            product: .app,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Initialization.example",
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .Initialization),
                .feature(testing: .Initialization),
            ]
        ),


        // Tests
        .target(
            name: "FeatureInitializationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Initialization.tests",
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .Initialization),
                .feature(testing: .Initialization),
            ]
        ),
        
        
        // Testing
        .target(
            name: "FeatureInitializationTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Initialization.testing",
            sources: ["Testing/**"],
            dependencies: [
                .feature(implements: .Initialization),
            ]
        ),


        // Feature
        .target(
            name: "FeatureInitialization",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Initialization",
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                
                .feature(implements: .Home),
                
                .domain(interface: .UserState),
                
                .shared(implements: .DesignSystem),
                .shared(implements: .PresentationExt),
                
                .thirdParty(library: .RxCocoa),
                .thirdParty(library: .RxSwift),
                .thirdParty(library: .SnapKit),
                .thirdParty(library: .ReactorKit),
            ]
        ),
    ]
)
