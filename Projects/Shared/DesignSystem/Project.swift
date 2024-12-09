//
//  Project.swift
//
//  Created by choijunios on 2024/12/03
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "DesignSystem",
    targets: [

        // Shared
        .target(
            name: "SharedDesignSystem",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(Project.Environment.bundlePrefix).shared.DesignSystem",
            sources: ["Sources/**"],
            dependencies: [
                .shared(interface: .DesignSystem),
            ]
        ),

        // Interface
        .target(
            name: "SharedDesignSystemInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).shared.DesignSystem.interface",
            sources: ["Interface/**"],
            dependencies: [
                
                .thirdParty(library: .RxCocoa),
                .thirdParty(library: .SnapKit),
            ]
        ),
    ]
)
