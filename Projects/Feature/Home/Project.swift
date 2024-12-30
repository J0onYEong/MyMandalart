//
//  Project.swift
//
//  Created by choijunios on 2024/12/03
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Home",
    targets: [
        
        // Example
        .target(
            name: "FeatureHomeExample",
            destinations: .iOS,
            product: .app,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Home.example",
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                
                .feature(implements: .Home),
                .feature(testing: .Home),
            ]
        ),


        // Tests
        .target(
            name: "FeatureHomeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Home.tests",
            sources: ["Tests/**"],
            dependencies: [
                
                .feature(implements: .Home),
                .feature(testing: .Home),
            ]
        ),


        // Feature
        .target(
            name: "FeatureHome",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Home",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                
                // Feature
                .feature(implements: .SubMandarat),
                
                
                // Domain
                .domain(interface: .Mandarat),
                .domain(interface: .UserState),
                
                
                .shared(implements: .PresentationExt),
                .shared(implements: .DesignSystem),
                
                .thirdParty(library: .RxCocoa),
                .thirdParty(library: .ReactorKit),
                .thirdParty(library: .SnapKit),
            ]
        ),


        // Testing
        .target(
            name: "FeatureHomeTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Home.testing",
            sources: ["Testing/**"],
            dependencies: [
                .feature(implements: .Home),
            ]
        ),
    ]
)
