// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "ReactorKit": .framework,
        ]
    )
#endif

let package = Package(
    name: "MyMandarat",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        
        // ReactorKit
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        
        // RxSwift, RxCocoa, etc
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.8.0"),
        
        // Swinject
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        
        // SnapKit
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
    ]
)
