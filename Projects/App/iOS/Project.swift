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
                
                .feature(implements: .Home),
                .feature(implements: .SubMandarat),
                
                .domain(interface: .Mandarat),
                .domain(implements: .Mandarat),
                
                .data(interface: .Mandarat),
                .data(implements: .Mandarat),
                
                .data(interface: .CoreData),
                .data(implements: .CoreData),
                
                .thirdParty(library: .Swinject)
            ]
        )
    ]
)
