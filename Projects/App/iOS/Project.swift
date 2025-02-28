import ProjectDescription
import DependencyPlugin


let project = Project(
    name: "MyMandalart",
    targets: [
        .target(
            name: "MyMandalart-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "\(Project.Environment.bundlePrefix).app",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: InfoPlist.app,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                
                .feature(implements: .Initialization),
                
                
                .domain(implements: .Mandarat),
                .domain(implements: .UserState),
                
                
                .data(implements: .Mandarat),
                .data(implements: .CoreData),
                .data(implements: .UserState),
                
                
                .shared(implements: .Logger),
            ],
            settings: .settings(
            base: [
                "AMPLITUDE_API_KEY" : "$(inherited)"
            ],
            configurations: [
                .debug(name: "Debug"),
                .release(
                    name: "Release",
                    xcconfig: .relativeToRoot("Secrets/Release.xcconfig")
                )
            ])
        )
    ],
    schemes: [
        
        // MARK: Debug scheme
        .scheme(
            name: "MyMandalart_Debug",
            buildAction: .buildAction(
                targets: [ .target("MyMandalart-iOS") ]
            ),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Debug")
        ),
        
        // MARK: Release scheme
        .scheme(
            name: "MyMandalart_Release",
            buildAction: .buildAction(
                targets: [ .target("MyMandalart-iOS") ]
            ),
            runAction: .runAction(configuration: "Release"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
