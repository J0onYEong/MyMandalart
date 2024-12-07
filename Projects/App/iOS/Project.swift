import ProjectDescription
import DependencyPlugin


let project = Project(
    name: "MyMandarat",
    targets: [
        .target(
            name: "MyMandarat-iOS",
            destinations: .iOS,
            product: .app,
            productName: "MyMandarat",
            bundleId: "\(Project.Environment.bundlePrefix).app",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: InfoPlist.app,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                
                .thirdParty(library: .Swinject)
            ]
        )
    ]
)
