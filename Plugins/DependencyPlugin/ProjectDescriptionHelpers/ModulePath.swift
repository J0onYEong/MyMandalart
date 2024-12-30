
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
        case SubMandarat
        case Initialization
        
        public static let categoryName: String = "Feature"

    }
    
}


// MARK: Domain module

public extension ModulePath {
    
    enum Domain: String, CaseIterable {
        
        case Mandarat
        case UserState
        
        public static let categoryName: String = "Domain"
        
    }
    
}


// MARK: Data module

public extension ModulePath {
    
    enum Data: String, CaseIterable {
        
        // Repository
        case Mandarat
        case UserState
        
        
        // DataSource
        case CoreData
        
        public static let categoryName: String = "Data"
        
    }
    
}


// MARK: Shared module

public extension ModulePath {
    
    enum Shared: String, CaseIterable {
        
        case Core
        case DesignSystem
        case PresentationExt
        
        public static let categoryName: String = "Shared"
        
    }
    
}


// MARK: Third party

public extension ModulePath {
    
    enum ThirdParty: String, CaseIterable {
        
        case RxSwift
        case RxCocoa
        case RxTest
        case ReactorKit
        case SnapKit
        
        public static let categoryName: String = "ThirdParty"
    }
}
