import SwiftUI

// TODO: Make this public
enum Color: Codable, Hashable {
    case hsb(HSB)
    case hsba(HSBA)
    case rgb(RGB)
    case rgba(RGBA)
    // TODO: hex?
}

public struct Red: Codable, Hashable, RawRepresentable {
    public static let bounds: ClosedRange<Int> = 0 ... 255

    public private(set) var rawValue: Int

    public init?(rawValue: Int) {
        guard Self.bounds.contains(rawValue) else { return nil }
        self.rawValue = rawValue
    }

    public init?(_ rawValue: Int) {
        self.init(rawValue: rawValue)
    }
}

public struct Green: Codable, Hashable, RawRepresentable {
    public static let bounds: ClosedRange<Int> = 0 ... 255

    public private(set) var rawValue: Int

    public init?(rawValue: Int) {
        guard Self.bounds.contains(rawValue) else { return nil }
        self.rawValue = rawValue
    }

    public init?(_ rawValue: Int) {
        self.init(rawValue: rawValue)
    }
}

public struct Blue: Codable, Hashable, RawRepresentable {
    public static let bounds: ClosedRange<Int> = 0 ... 255

    public private(set) var rawValue: Int

    public init?(rawValue: Int) {
        guard Self.bounds.contains(rawValue) else { return nil }
        self.rawValue = rawValue
    }

    public init?(_ rawValue: Int) {
        self.init(rawValue: rawValue)
    }
}

public struct RGB: Codable, Hashable {
    public var red: Red
    public var green: Green
    public var blue: Blue

    public init?(red: Int, green: Int, blue: Int) {
        guard
            let red = Red(red),
            let blue = Blue(blue),
            let green = Green(green)
        else { return nil }
        self.red = red
        self.green = green
        self.blue = blue
    }

    public init(red: Red, green: Green, blue: Blue) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public init(rgba: RGBA) {
        red = rgba.red
        green = rgba.green
        blue = rgba.blue
    }
}

public struct RGBA: Codable, Hashable {
    public var red: Red
    public var green: Green
    public var blue: Blue
    public var alpha: Alpha

    public init?(red: Int, green: Int, blue: Int, alpha: Double) {
        guard
            let red = Red(red),
            let blue = Blue(blue),
            let green = Green(green),
            let alpha = Alpha(alpha)
        else { return nil }
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public init(red: Red, green: Green, blue: Blue, alpha: Alpha) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public init(rgb: RGB, alpha: Alpha = .one) {
        red = rgb.red
        green = rgb.green
        blue = rgb.blue
        self.alpha = alpha
    }
}

public struct Hue: Codable, Hashable, RawRepresentable {
    public static let bounds: ClosedRange<Int> = 0 ... 360

    public private(set) var rawValue: Int

    public init?(rawValue: Int) {
        guard Self.bounds.contains(rawValue) else { return nil }
        self.rawValue = rawValue
    }

    public init?(_ rawValue: Int) {
        self.init(rawValue: rawValue)
    }
}

public struct Saturation: Codable, Hashable, RawRepresentable {
    public static let bounds: ClosedRange<Int> = 0 ... 100

    public private(set) var rawValue: Int

    public init?(rawValue: Int) {
        guard Self.bounds.contains(rawValue) else { return nil }
        self.rawValue = rawValue
    }

    public init?(_ rawValue: Int) {
        self.init(rawValue: rawValue)
    }
}

public struct Brightness: Codable, Hashable, RawRepresentable {
    public static let bounds: ClosedRange<Int> = 0 ... 100

    public private(set) var rawValue: Int

    public init?(rawValue: Int) {
        guard Self.bounds.contains(rawValue) else { return nil }
        self.rawValue = rawValue
    }

    public init?(_ rawValue: Int) {
        self.init(rawValue: rawValue)
    }
}

public struct Alpha: Codable, Hashable, RawRepresentable {
    public static let bounds: ClosedRange<Double> = 0 ... 1
    public static let zero = Alpha(rawValue: 0)!
    public static let one = Alpha(rawValue: 1)!

    public private(set) var rawValue: Double

    public init?(rawValue: Double) {
        guard Self.bounds.contains(rawValue) else { return nil }
        self.rawValue = rawValue
    }

    public init?(_ rawValue: Double) {
        self.init(rawValue: rawValue)
    }
}

public extension UIImage {
    @inlinable func draw(in rect: CGRect, blendMode: CGBlendMode, alpha: Alpha) {
        draw(in: rect, blendMode: blendMode, alpha: alpha.rawValue)
    }
}

public extension UIColor {
    @inlinable func withAlphaComponent(_ alpha: Alpha) -> UIColor {
        withAlphaComponent(alpha.rawValue)
    }
}

public extension View {
    @inlinable func opacity(_ alpha: Alpha) -> some View {
        opacity(alpha.rawValue)
    }
}

public struct HSB: Codable, Hashable {
    public var hue: Hue
    public var saturation: Saturation
    public var brightness: Brightness

    public init?(hue: Int, saturation: Int, brightness: Int) {
        guard
            let hue = Hue(hue),
            let brightness = Brightness(brightness),
            let saturation = Saturation(saturation)
        else { return nil }
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }

    public init(hue: Hue, saturation: Saturation, brightness: Brightness) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }

    public init(hsba: HSBA) {
        hue = hsba.hue
        saturation = hsba.saturation
        brightness = hsba.brightness
    }
}

public struct HSBA: Codable, Hashable {
    public var hue: Hue
    public var saturation: Saturation
    public var brightness: Brightness
    public var alpha: Alpha

    public init?(hue: Int, saturation: Int, brightness: Int, alpha: Double) {
        guard
            let hue = Hue(hue),
            let brightness = Brightness(brightness),
            let saturation = Saturation(saturation),
            let alpha = Alpha(alpha)
        else { return nil }
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }

    public init(hue: Hue, saturation: Saturation, brightness: Brightness, alpha: Alpha) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }

    public init(hsb: HSB, alpha: Alpha = .one) {
        hue = hsb.hue
        saturation = hsb.saturation
        brightness = hsb.brightness
        self.alpha = alpha
    }
}
