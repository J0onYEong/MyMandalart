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
