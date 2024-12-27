//
//  Project.swift
//
//  Created by choijunios on 2024/12/10
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "AlertHelper",
    targets: [

        // Shared
        .target(
            name: "SharedAlertHelper",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).shared.AlertHelper",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                .shared(interface: .AlertHelper),
            ]
        ),

        // Interface
        .target(
            name: "SharedAlertHelperInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).shared.AlertHelper.interface",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Interface/**"],
            dependencies: [
                .shared(interface: .Navigation)
            ]
        ),
    ]
)
