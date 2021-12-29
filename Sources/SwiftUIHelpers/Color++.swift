import Foundation
import SwiftUI

public extension SwiftUI.Color {
    init(hue: Int, saturation: Int, brightness: Int, opacity: Double = 1) {
        self.init(
            hue: Double(hue) / 360.0,
            saturation: Double(saturation) / 100.0,
            brightness: Double(brightness) / 100.0,
            opacity: opacity
        )
    }

    // Converts HSB values from Figma into SwiftUI's colorspace.
    // Reference:: https://stackoverflow.com/a/39144203/8639572
    static func hsb(_ hue: Double, _ saturation: Double, _ brightness: Double) -> SwiftUI.Color {
        SwiftUI.Color(hue: hue / 360, saturation: saturation / 100, brightness: brightness / 100)
    }

    static func hsb(_ hue: Double, _ saturation: Double, _ brightness: Double, _ opacity: Double) -> SwiftUI.Color {
        // TODO: Not sure about dividing opacity by 100
        SwiftUI.Color(hue: hue / 360, saturation: saturation / 100, brightness: brightness / 100, opacity: opacity)
    }

    // https://gist.github.com/nelglez/1c5460f815ef18bbc044f62e4671d4f7
    static func hex(_ hex: String) -> Self {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = .init(utf16Offset: 0, in: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF

        return Self(
            red: Double(r) / 0xFF,
            green: Double(g) / 0xFF,
            blue: Double(b) / 0xFF,
            opacity: 1
        )
    }
}
