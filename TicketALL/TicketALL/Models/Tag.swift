import SwiftUI
import SwiftData

@Model
final class Tag {
    var id: UUID
    var name: String
    var color: String
    var isSystem: Bool
    
    init(id: UUID = UUID(), name: String, color: String, isSystem: Bool = false) {
        self.id = id
        self.name = name
        self.color = color
        self.isSystem = isSystem
    }
    
    var uiColor: Color {
        Color(hex: color) ?? .blue
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let length = hexSanitized.count
        
        let red, green, blue, alpha: Double
        
        switch length {
        case 6:
            red = Double((rgb >> 16) & 0xFF) / 255.0
            green = Double((rgb >> 8) & 0xFF) / 255.0
            blue = Double(rgb & 0xFF) / 255.0
            alpha = 1.0
        case 8:
            red = Double((rgb >> 24) & 0xFF) / 255.0
            green = Double((rgb >> 16) & 0xFF) / 255.0
            blue = Double((rgb >> 8) & 0xFF) / 255.0
            alpha = Double(rgb & 0xFF) / 255.0
        default:
            return nil
        }
        
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    func toHex() -> String {
        guard let components = cgColor?.components, components.count >= 3 else {
            return "#007AFF"
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(red * 255),
            lroundf(green * 255),
            lroundf(blue * 255)
        )
    }
}
