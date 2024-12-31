import ProjectDescription
import DependencyPlugin


let project = Project(
    name: "MyMandalart",
    targets: [
        .target(
            name: "MyMandalart-iOS",
            destinations: .iOS,
            product: .app,
            productName: Project.Environment.appName,
            bundleId: "\(Project.Environment.bundlePrefix).app",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: InfoPlist.app,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                
                .feature(implements: .Initialization),
                
                
                .domain(interface: .Mandarat),
                .domain(implements: .Mandarat),
                
                .domain(interface: .UserState),
                .domain(implements: .UserState),
                
                
                .data(interface: .Mandarat),
                .data(implements: .Mandarat),
                
                .data(interface: .CoreData),
                .data(implements: .CoreData),
                
                .data(implements: .UserState),
            ]
        )
    ]
)
