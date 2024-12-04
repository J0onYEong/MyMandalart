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
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).shared.Core",
            sources: ["Sources/**"],
            dependencies: [
                .shared(interface: .Core),
            ]
        ),

        // Interface
        .target(
            name: "SharedCoreInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).shared.Core.interface",
            sources: ["Interface/**"],
            dependencies: [
                
                .thirdParty(library: .Swinject)
            ]
        ),
    ]
)
