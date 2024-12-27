//
//  Project.swift
//
//  Created by choijunios on 2024/12/26
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "PresentationExt",
    targets: [

        // Shared
        .target(
            name: "SharedPresentationExt",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Project.Environment.bundlePrefix).shared.PresentationExt",
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: [
                .shared(implements: .Core),
                .thirdParty(library: .RxCocoa),
                .thirdParty(library: .RxSwift),
            ]
        ),
    ]
)
