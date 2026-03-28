import SwiftUI

// MARK: - Design System Colors
extension Color {
    // Base
    static let appBackground = Color(hex: "FDF8F5") // Cream / Pale Shell
    static let cardBackground = Color.white
    
    // Primary
    static let appTextPrimary = Color(hex: "2D3D88") // Deep Indigo
    static let appTextSecondary = Color(hex: "5D6CA8") // Lighter Indigo/Slate
    
    // Accent
    static let appAccent = Color(hex: "E58B74") // Terra Cotta
    static let appAccentHighlight = Color(hex: "F2A896")
    
    // Support
    static let supportYellow = Color(hex: "F4D06F")
    static let supportTeal = Color(hex: "88CCCA")
    static let supportBlue = Color(hex: "889FCC")
    static let supportLavender = Color(hex: "AC92EC")
    
    // Light variations for ToDo backgrounds
    static let supportBlueLight = Color(hex: "E0E7F5")
    static let supportLavenderLight = Color(hex: "F0EBFA")
    static let supportCoralLight = Color(hex: "F9EBE8")
}

// MARK: - Hex Color Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography
extension Font {
    static let appTitle = Font.system(size: 28, weight: .bold, design: .default)
    static let appHeadline = Font.system(size: 20, weight: .bold, design: .rounded)
    static let appSubheadline = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let appBody = Font.system(size: 16, weight: .regular, design: .default)
    static let appCaption = Font.system(size: 14, weight: .regular, design: .default)
    
    // Numbers
    static let appNumberLarge = Font.system(size: 32, weight: .light, design: .default)
}
