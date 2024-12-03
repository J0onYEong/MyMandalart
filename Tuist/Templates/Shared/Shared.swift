//
//  Shared.swift
//
//

import Foundation
import ProjectDescription

private let name: Template.Attribute = .required("name")
private let author: Template.Attribute = .required("author")
private let currentDate: Template.Attribute = .required("currentDate")

let projectPath = "Projects/Shared/\(name)"

let sharedTemplate = Template(
    description: "A template for a new shared module",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [

        // Shared
        
        .item(path: "\(projectPath)", contents: .directory(.relativeToRoot("Scaffold/Shared/Sources"))),
            
        
        // Interface
        
        .item(path: "\(projectPath)/Interface/Interface.swift", contents: .file(.relativeToRoot("Scaffold/Shared/Interface/Interface.swift"))),
        
        
        // Project.swift
        
        .file(
            path: "\(projectPath)/Project.swift",
            templatePath: .relativeToRoot("Scaffold/Shared/Project.stencil")
        ),
    ]
)
