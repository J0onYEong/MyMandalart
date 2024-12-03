//
//  Feature.swift
//
//

import Foundation
import ProjectDescription

private let name: Template.Attribute = .required("name")
private let author: Template.Attribute = .required("author")
private let currentDate: Template.Attribute = .required("currentDate")

let projectPath = "Projects/Feature/\(name)"

let featureTemplate = Template(
    description: "A template for a new feature module",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [
        
        // Example
        
        .item(path: "\(projectPath)/Example", contents: .directory(.relativeToRoot("Scaffold/Feature/Example/Sources"))),
        
        .item(path: "\(projectPath)/Example", contents: .directory(.relativeToRoot("Scaffold/Feature/Example/Resources"))),
        
        
        // Tests
        
        .item(path: "\(projectPath)/Tests/Tests.swift", contents: .file(.relativeToRoot("Scaffold/Feature/Tests/Tests.swift"))),
        
        
        // Feature
        
        .item(path: "\(projectPath)/Feature", contents: .directory(.relativeToRoot("Scaffold/Feature/Feature/Sources"))),
            
        .item(path: "\(projectPath)/Feature", contents: .directory(.relativeToRoot("Scaffold/Feature/Feature/Resources"))),
        
        
        // Testing
        
        .item(path: "\(projectPath)/Testing/Testing.swift", contents: .file(.relativeToRoot("Scaffold/Feature/Testing/Testing.swift"))),
        
        
        // Interface
        
        .item(path: "\(projectPath)/Interface/Interface.swift", contents: .file(.relativeToRoot("Scaffold/Feature/Interface/Interface.swift"))),
        
        
        // Project.swift
        
        .file(
            path: "\(projectPath)/Project.swift",
            templatePath: .relativeToRoot("Scaffold/Feature/Project.stencil")
        ),
    ]
)
