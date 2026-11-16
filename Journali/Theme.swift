//
//  Theme.swift
//  Journali
//
//  Created by Jumana Khawaij on 06/06/1448 AH.
//
import SwiftUI

extension Color {
    static let primaryText = Color(hex: "FFFFFF")
    static let secondaryText = Color(hex: "A39A9A")
    static let accentText = Color(hex: "AF99FD")
    static let accentPrimary = Color(hex: "7F81FF")
    static let cardSurface = Color(hex: "1C1C1E")
    static let semantic = Color(hex: "FD453C")
    static let orange = Color(hex: "B75718")
}

// مساعد لتحويل الأكواد الستينية (Hex) إلى ألوان في SwiftUI
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

// Typography Sizes
struct AppFonts {
    static let display: CGFloat = 42
    static let headingL: CGFloat = 34
    static let headingM: CGFloat = 24
    static let bodyL: CGFloat = 20
    static let bodyM: CGFloat = 18
    static let captionM: CGFloat = 16
    static let captionS: CGFloat = 14
}
