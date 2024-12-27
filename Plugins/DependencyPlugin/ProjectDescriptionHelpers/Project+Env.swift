import Foundation
import ProjectDescription


public extension Project {
    
    enum Environment {
        
        public static let appName: String = "MyMandarat"
        public static let deploymentTarget: DeploymentTargets = .iOS("18.0")
        public static let bundlePrefix: String = "com.choijunyeong.mymandarat"
        
    }
}

