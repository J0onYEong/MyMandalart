import Foundation
import ProjectDescription


public extension Project {
    
    enum Environment {
        
        public static let appName: String = "MyMandalart"
        public static let deploymentTarget: DeploymentTargets = .iOS("18.0")
        public static let bundlePrefix: String = "com.choijunyeong.mymandalart"
        
    }
}

