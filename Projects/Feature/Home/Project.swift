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
            deploymentTargets: Project.Environment.deploymentTarget,
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
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                
                .feature(implements: .Home),
                .feature(testing: .Home),
            ]
        ),
        
        
        // Testing
        .target(
            name: "FeatureHomeTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Home.testing",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Testing/**"],
            dependencies: [
                .feature(implements: .Home),
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
                .feature(implements: .Setting),
                
                
                // Domain
                .domain(interface: .Mandarat),
                .domain(interface: .UserState),
                
                
                .shared(interface: .Logger),
                .shared(implements: .PresentationExt),
                .shared(implements: .DesignSystem),
                
                
//                .thirdParty(library: .RxCocoa),
//                .thirdParty(library: .RxSwift),
                .thirdParty(library: .ReactorKit),
                .thirdParty(library: .SnapKit),
            ]
        ),
    ]
)
