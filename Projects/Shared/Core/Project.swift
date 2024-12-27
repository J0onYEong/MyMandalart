//
//  Project.swift
//
//  Created by choijunios on 2024/12/04
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Core",
    targets: [

        // Shared
        .target(
            name: "SharedCore",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).shared.Core",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                
            ]
        ),
    ]
)
