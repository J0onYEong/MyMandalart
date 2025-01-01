//
//  Project.swift
//
//  Created by choijunios on 2025/01/02
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Logger",
    targets: [

        // Shared
        .target(
            name: "SharedLogger",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).shared.Logger",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                .shared(interface: .Logger),
            ]
        ),

        // Interface
        .target(
            name: "SharedLoggerInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).shared.Logger.interface",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Interface/**"],
            dependencies: [
                
            ]
        ),
    ]
)
