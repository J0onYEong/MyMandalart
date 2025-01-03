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
            "RxRelay": .framework,
            "RxTest": .framework,
            "ReactorKit": .framework,
            "SnapKit": .framework,
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
//        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.8.0"),
        
        
        // SnapKit
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
        
        
        // Amplitude
        .package(url: "https://github.com/amplitude/Amplitude-Swift", from: "1.9.2"),
    ]
)
