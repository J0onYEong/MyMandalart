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
                .thirdParty(library: .RxCocoa),
                .thirdParty(library: .SnapKit),
            ]
        ),
    ]
)
