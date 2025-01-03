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
            deploymentTargets: Project.Environment.deploymentTarget,
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
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .SubMandarat),
                .feature(testing: .SubMandarat),
            ]
        ),
        
        
        // Testing
        .target(
            name: "FeatureSubMandaratTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.SubMandarat.testing",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Testing/**"],
            dependencies: [
                .feature(implements: .SubMandarat),
            ]
        ),


        // Feature
        .target(
            name: "FeatureSubMandarat",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.SubMandarat",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                
                .domain(interface: .Mandarat),
                .domain(interface: .UserState),
                
                
                .shared(interface: .Logger),
                .shared(implements: .PresentationExt),
                .shared(implements: .DesignSystem),
                
                
                .thirdParty(library: .RxCocoa),
                .thirdParty(library: .ReactorKit),
                .thirdParty(library: .SnapKit),
            ]
        ),
    ]
)
