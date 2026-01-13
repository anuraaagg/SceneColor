import SwiftUI

/// Color information with hex, name, and RGB values
struct ColorInfo: Codable, Identifiable {
    let id: UUID
    let hex: String
    let name: String
    let r: Int
    let g: Int
    let b: Int
    
    init(id: UUID = UUID(), hex: String, name: String, r: Int, g: Int, b: Int) {
        self.id = id
        self.hex = hex
        self.name = name
        self.r = r
        self.g = g
        self.b = b
    }
    
    init(color: UIColor) {
        self.id = UUID()
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.r = Int(red * 255)
        self.g = Int(green * 255)
        self.b = Int(blue * 255)
        self.hex = String(format: "#%02X%02X%02X", self.r, self.g, self.b)
        self.name = ColorNamer.shared.name(for: color)
    }
    
    var color: Color {
        Color(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0)
    }
    
    var uiColor: UIColor {
        UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
}
