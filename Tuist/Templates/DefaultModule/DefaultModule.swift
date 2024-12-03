//
//  DefaultModule.swift
//
//

import Foundation
import ProjectDescription

private let name: Template.Attribute = .required("name")
private let layer: Template.Attribute = .required("layer")
private let author: Template.Attribute = .required("author")
private let currentDate: Template.Attribute = .required("currentDate")


let projectPath = "Projects/\(layer)/\(name)"

let domainTemplate = Template(
    description: "A template for a new \(layer) module",
    attributes: [
        name,
        layer,
        author,
        currentDate
    ],
    items: [
        
        // Tests
        
        .item(path: "\(projectPath)/Tests/Tests.swift", contents: .file(.relativeToRoot("Scaffold/DefaultModule/Tests/Tests.swift"))),
        
        
        // Domain
        
        .item(path: "\(projectPath)", contents: .directory(.relativeToRoot("Scaffold/DefaultModule/Sources"))),
            
        
        // Testing
        
        .item(path: "\(projectPath)/Testing/Testing.swift", contents: .file(.relativeToRoot("Scaffold/DefaultModule/Testing/Testing.swift"))),
        
        
        // Interface
        
        .item(path: "\(projectPath)/Interface/Interface.swift", contents: .file(.relativeToRoot("Scaffold/DefaultModule/Interface/Interface.swift"))),
        
        
        // Project.swift
        
        .file(
            path: "\(projectPath)/Project.swift",
            templatePath: .relativeToRoot("Scaffold/DefaultModule/Project.stencil")
        ),
    ]
)
