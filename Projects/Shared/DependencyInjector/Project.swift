//
//  Project.swift
//
//  Created by choijunios on 2024/12/07
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "DependencyInjector",
    targets: [

        // Shared
        .target(
            name: "SharedDependencyInjector",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).shared.DependencyInjector",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                .shared(implements: .PresentationExt),
                .thirdParty(library: .Swinject),
            ]
        ),
    ]
)
