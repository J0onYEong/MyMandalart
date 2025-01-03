//
//  Project.swift
//
//  Created by choijunios on 2024/12/31
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Setting",
    targets: [
        
        // Example
        .target(
            name: "FeatureSettingExample",
            destinations: .iOS,
            product: .app,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Setting.example",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .Setting),
                .feature(testing: .Setting),
            ]
        ),


        // Tests
        .target(
            name: "FeatureSettingTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Setting.tests",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .Setting),
                .feature(testing: .Setting),
            ]
        ),


        // Testing
        .target(
            name: "FeatureSettingTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Setting.testing",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Testing/**"],
            dependencies: [
                .feature(implements: .Setting),
            ]
        ),


        // Feature
        .target(
            name: "FeatureSetting",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.Setting",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                .domain(interface: .UserState),
                
                
                .shared(implements: .PresentationExt),
                .shared(implements: .DesignSystem),
                
                .thirdParty(library: .RxCocoa),
                .thirdParty(library: .ReactorKit),
                .thirdParty(library: .SnapKit),
            ]
        ),
    ]
)
