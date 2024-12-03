//
//  Data.swift
//
//

import Foundation
import ProjectDescription

private let name: Template.Attribute = .required("name")
private let author: Template.Attribute = .required("author")
private let currentDate: Template.Attribute = .required("currentDate")

let projectPath = "Projects/Data/\(name)"

let dataTemplate = Template(
    description: "A template for a new data module",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [
        
        // Tests
        
        .item(path: "\(projectPath)/Tests/Tests.swift", contents: .file(.relativeToRoot("Scaffold/Data/Tests/Tests.swift"))),
        
        
        // Data
        
        .item(path: "\(projectPath)", contents: .directory(.relativeToRoot("Scaffold/Data/Sources"))),
            
        
        // Testing
        
        .item(path: "\(projectPath)/Testing/Testing.swift", contents: .file(.relativeToRoot("Scaffold/Data/Testing/Testing.swift"))),
        
        
        // Interface
        
        .item(path: "\(projectPath)/Interface/Interface.swift", contents: .file(.relativeToRoot("Scaffold/Data/Interface/Interface.swift"))),
        
        
        // Project.swift
        
        .file(
            path: "\(projectPath)/Project.swift",
            templatePath: .relativeToRoot("Scaffold/Data/Project.stencil")
        ),
    ]
)
