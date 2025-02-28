import Foundation
import ProjectDescription


public extension Project {
    
    enum Environment {
        
        public static let appName: String = "마이만다라트"
        public static let deploymentTarget: DeploymentTargets = .iOS("17.5")
        public static let bundlePrefix: String = "com.choijunyeong.mymandalart"
        
    }
}

