import Foundation
import UIKit

/// Provides color naming for extracted colors
class ColorNamer {
    static let shared = ColorNamer()
    
    private init() {}
    
    /// Get a human-readable name for a color
    func name(for color: UIColor) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        // Find nearest named color from database
        var minDistance = Double.infinity
        var closestName = "Unknown"
        
        for (name, namedColor) in colorDatabase {
            let distance = colorDistance(r1: r, g1: g, b1: b,
                                        r2: namedColor.r, g2: namedColor.g, b2: namedColor.b)
            if distance < minDistance {
                minDistance = distance
                closestName = name
            }
        }
        
        return closestName
    }
    
    /// Calculate Euclidean distance between two colors
    private func colorDistance(r1: Int, g1: Int, b1: Int, r2: Int, g2: Int, b2: Int) -> Double {
        let dr = Double(r1 - r2)
        let dg = Double(g1 - g2)
        let db = Double(b1 - b2)
        return sqrt(dr * dr + dg * dg + db * db)
    }
    
    /// Simplified color database (subset of CSS colors)
    private let colorDatabase: [String: (r: Int, g: Int, b: Int)] = [
        "Black": (0, 0, 0),
        "White": (255, 255, 255),
        "Red": (255, 0, 0),
        "Green": (0, 128, 0),
        "Blue": (0, 0, 255),
        "Yellow": (255, 255, 0),
        "Cyan": (0, 255, 255),
        "Magenta": (255, 0, 255),
        "Orange": (255, 165, 0),
        "Purple": (128, 0, 128),
        "Pink": (255, 192, 203),
        "Brown": (165, 42, 42),
        "Gray": (128, 128, 128),
        "Navy": (0, 0, 128),
        "Teal": (0, 128, 128),
        "Olive": (128, 128, 0),
        "Maroon": (128, 0, 0),
        "Lime": (0, 255, 0),
        "Aqua": (0, 255, 255),
        "Silver": (192, 192, 192),
        "Gold": (255, 215, 0),
        "Coral": (255, 127, 80),
        "Salmon": (250, 128, 114),
        "Khaki": (240, 230, 140),
        "Lavender": (230, 230, 250),
        "Beige": (245, 245, 220),
        "Ivory": (255, 255, 240),
        "Mint": (189, 252, 201),
        "Peach": (255, 229, 180),
        "Sky Blue": (135, 206, 235),
        "Forest Green": (34, 139, 34),
        "Crimson": (220, 20, 60),
        "Indigo": (75, 0, 130)
    ]
}
