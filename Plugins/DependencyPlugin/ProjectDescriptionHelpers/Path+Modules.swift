import Foundation
import ProjectDescription

// MARK: ProjectDescription.Path + App

public extension ProjectDescription.Path {
    
    static var app: Self {
        
        return .relativeToRoot("Projects/\(ModulePath.App.categoryName)")
    }
    
}


// MARK: ProjectDescription.Path + Feature

public extension ProjectDescription.Path {
    
    /// Feature모듈들이 존재하는 경로를 반환합니다.
    static var feature: Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Feature.categoryName)")
    }
    
    
    /// 특정 Feature모듈의 경로를 반환합니다.
    static func feature(implementation module: ModulePath.Feature) -> Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Feature.categoryName)/\(module.rawValue)")
    }
}


// MARK: ProjectDescription.Path + Domain

public extension ProjectDescription.Path {
    
    /// Domain모듈들이 존재하는 경로를 반환합니다.
    static var domain: Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Domain.categoryName)")
    }
    
    
    /// 특정 Domain모듈의 경로를 반환합니다.
    static func domain(implementation module: ModulePath.Domain) -> Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Domain.categoryName)/\(module.rawValue)")
    }
}


// MARK: ProjectDescription.Path + Data

public extension ProjectDescription.Path {
    
    /// Data모듈들이 존재하는 경로를 반환합니다.
    static var data: Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Data.categoryName)")
    }
    
    
    /// 특정 Data모듈의 경로를 반환합니다.
    static func data(implementation module: ModulePath.Data) -> Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Data.categoryName)/\(module.rawValue)")
    }
}


// MARK: ProjectDescription.Path + Shared

public extension ProjectDescription.Path {
    
    /// Shared모듈들이 존재하는 경로를 반환합니다.
    static var shared: Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Shared.categoryName)")
    }
    
    
    /// 특정 Shared모듈의 경로를 반환합니다.
    static func shared(implementation module: ModulePath.Shared) -> Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Shared.categoryName)/\(module.rawValue)")
    }
}
