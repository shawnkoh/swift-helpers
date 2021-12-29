import CoreGraphics

public extension Double {
    static func convertRadiansToDegrees(radians: Double) -> Double {
        radians * 180 / Double.pi
    }
}
