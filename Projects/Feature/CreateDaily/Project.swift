//
//  Project.swift
//
//  Created by choijunios on 2025/02/28
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "CreateDaily",
    targets: [
        
        // Example
        .target(
            name: "FeatureCreateDailyExample",
            destinations: .iOS,
            product: .app,
            bundleId: "\(Project.Environment.bundlePrefix).feature.CreateDaily.example",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .app_plist(with: [
                "NSSpeechRecognitionUsageDescription" : "일기를 작성하기 위해 사용합니다."
            ]),
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .CreateDaily),
                .feature(testing: .CreateDaily),
            ]
        ),


        // Tests
        .target(
            name: "FeatureCreateDailyTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Project.Environment.bundlePrefix).feature.CreateDaily.tests",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .CreateDaily),
                .feature(testing: .CreateDaily),
            ]
        ),


        // Testing
        .target(
            name: "FeatureCreateDailyTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.CreateDaily.testing",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Testing/**"],
            dependencies: [
                .feature(implements: .CreateDaily),
            ]
        ),


        // Feature
        .target(
            name: "FeatureCreateDaily",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(Project.Environment.bundlePrefix).feature.CreateDaily",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                
                
                
                .shared(implements: .PresentationExt),
                .shared(implements: .DesignSystem),
                
                
                .thirdParty(library: .ReactorKit),
                .thirdParty(library: .SnapKit),
            ]
        ),
    ]
)
