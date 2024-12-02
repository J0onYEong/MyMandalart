
// Created by choijunyeong

import Foundation
import ProjectDescription

public enum ModulePath {
    
    case feature(Feature)
    case domain(Domain)
    case data(Data)
    case shared(Shared)
    
}


// MARK: App module

public extension ModulePath {
    
    enum App: String, CaseIterable {
        
        case iOS
        
        public static let categoryName = "App"
        
    }
    
}


// MARK: Feature module

public extension ModulePath {
    
    enum Feature: String, CaseIterable {
        
        case Home
        
        public static let categoryName: String = "Feature"

    }
    
}


// MARK: Domain module

public extension ModulePath {
    
    enum Domain: String, CaseIterable {
        
        case Mandarat
        
        public static let categoryName: String = "Domain"
        
    }
    
}


// MARK: Data module

public extension ModulePath {
    
    enum Data: String, CaseIterable {
        
        case CoreData
        
        public static let categoryName: String = "Data"
        
    }
    
}


// MARK: Shared module

public extension ModulePath {
    
    enum Shared: String, CaseIterable {
        
        case Util
        case DesignSystem
        case ThirdPartyLib
        
        public static let categoryName: String = "Shared"
        
    }
    
}
