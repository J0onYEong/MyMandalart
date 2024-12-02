import ProjectDescription

let project = Project(
    name: "MyMandarat",
    targets: [
        .target(
            name: "MyMandarat",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.MyMandarat",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["MyMandarat/Sources/**"],
            resources: ["MyMandarat/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "MyMandaratTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.MyMandaratTests",
            infoPlist: .default,
            sources: ["MyMandarat/Tests/**"],
            resources: [],
            dependencies: [.target(name: "MyMandarat")]
        ),
    ]
)
