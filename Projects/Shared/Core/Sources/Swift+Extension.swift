//
//  Swift+Extension.swift
//  Core
//
//  Created by choijunios on 12/11/24.
//

import UIKit


public extension UIColor {
    
    func getTriadicColors() -> [UIColor] {
        
        let hsb = colorToHSB(self)
        
        // Calculate triadic hues (120 degrees apart)
        let hue1 = fmod(hsb.hue + 0.333, 1.0) // Add 120 degrees
        let hue2 = fmod(hsb.hue + 0.666, 1.0) // Add 240 degrees
        
        // Generate UIColor objects for triadic colors
        let color1 = hsbToColor(hue: hue1, saturation: hsb.saturation, brightness: hsb.brightness)
        let color2 = hsbToColor(hue: hue2, saturation: hsb.saturation, brightness: hsb.brightness)
        
        // Convert colors back to HEX strings
        return [color1, color2]
    }
    
    func getAnalogousColors() -> [UIColor] {
        
        // 1. UIColor -> HSB(Hue, Saturation, Brightness)로 변환
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // 2. 유사색 계산
        let analogousHue1 = fmod(hue + 30.0 / 360.0, 1.0) // Hue는 0~1 범위
        let analogousHue2 = fmod(hue + 60.0 / 360.0, 1.0) // 음수 방지
        
        // 3. HSB 값을 기반으로 UIColor 생성
        let analogousColor1 = UIColor(hue: analogousHue1, saturation: saturation, brightness: brightness, alpha: alpha)
        let analogousColor2 = UIColor(hue: analogousHue2, saturation: saturation, brightness: brightness, alpha: alpha)
        
        // 4. 결과 반환 (원본 색상 포함)
        return [analogousColor1, analogousColor2]
    }
    
    
    var isGrayScale: Bool {
        
        // UIColor -> RGB 변환
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // R, G, B 값이 모두 같으면 무채색
        return red == green && green == blue
    }
    
    
    func getInvertedColor() -> UIColor {
        var white: CGFloat = 0
        var alpha: CGFloat = 0
        
        _ = self.getWhite(&white, alpha: &alpha)
        
        let invertedWhite = 1.0 - white // 밝기를 반전
        return UIColor(white: invertedWhite, alpha: alpha)
    }
    
    
    static func color(_ hexString: String) -> UIColor? {

        var hexStringOnly = hexString
        
        if hexStringOnly.hasPrefix("#") {
            
            hexStringOnly.removeFirst()
        }
        
        guard hexStringOnly.count == 6 || hexStringOnly.count == 8 else { return nil }
        
        // Convert the string to UInt64
        var hexValue: UInt64 = 0
        Scanner(string: hexStringOnly).scanHexInt64(&hexValue)
        
        // Extract RGBA components
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat
        
        if hexStringOnly.count == 6 {
            // Format: RRGGBB
            red = CGFloat((hexValue >> 16) & 0xFF) / 255.0
            green = CGFloat((hexValue >> 8) & 0xFF) / 255.0
            blue = CGFloat(hexValue & 0xFF) / 255.0
            alpha = 1.0
        } else {
            // Format: RRGGBBAA
            red = CGFloat((hexValue >> 24) & 0xFF) / 255.0
            green = CGFloat((hexValue >> 16) & 0xFF) / 255.0
            blue = CGFloat((hexValue >> 8) & 0xFF) / 255.0
            alpha = CGFloat(hexValue & 0xFF) / 255.0
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString(includeAlpha: Bool = false) -> String? {
        
        // Get the color's components
        guard let components = cgColor.components, components.count >= 3 else {
            return nil // Return nil if the color doesn't have RGB components
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components.count >= 4 ? components[3] : 1.0
        
        if includeAlpha {
            return String(format: "#%02lX%02lX%02lX%02lX",
                          lround(Double(red * 255)),
                          lround(Double(green * 255)),
                          lround(Double(blue * 255)),
                          lround(Double(alpha * 255)))
        } else {
            return String(format: "#%02lX%02lX%02lX",
                          lround(Double(red * 255)),
                          lround(Double(green * 255)),
                          lround(Double(blue * 255)))
        }
    }
}


private extension UIColor {

    /// Converts UIColor to HSB (Hue, Saturation, Brightness)
    func colorToHSB(_ color: UIColor) -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue: hue, saturation: saturation, brightness: brightness)
    }

    /// Converts HSB values to UIColor
    func hsbToColor(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
