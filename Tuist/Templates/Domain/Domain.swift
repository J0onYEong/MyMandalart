//
//  Domain.swift
//
//

import Foundation
import ProjectDescription

private let name: Template.Attribute = .required("name")
private let author: Template.Attribute = .required("author")
private let currentDate: Template.Attribute = .required("currentDate")

let projectPath = "Projects/Domain/\(name)"

let domainTemplate = Template(
    description: "A template for a new domain module",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [
        
        // Tests
        
        .item(path: "\(projectPath)/Tests/Tests.swift", contents: .file(.relativeToRoot("Scaffold/Domain/Tests/Tests.swift"))),
        
        
        // Domain
        
        .item(path: "\(projectPath)", contents: .directory(.relativeToRoot("Scaffold/Domain/Sources"))),
            
        
        // Testing
        
        .item(path: "\(projectPath)/Testing/Testing.swift", contents: .file(.relativeToRoot("Scaffold/Domain/Testing/Testing.swift"))),
        
        
        // Interface
        
        .item(path: "\(projectPath)/Interface/Interface.swift", contents: .file(.relativeToRoot("Scaffold/Domain/Interface/Interface.swift"))),
        
        
        // Project.swift
        
        .file(
            path: "\(projectPath)/Project.swift",
            templatePath: .relativeToRoot("Scaffold/Domain/Project.stencil")
        ),
    ]
)
