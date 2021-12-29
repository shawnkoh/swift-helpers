import SwiftUI

public enum DeviceOrientation {
    case landscape
    case portrait
    case unknown
}

private struct DeviceOrientationEnvironmentKey: EnvironmentKey {
    static let defaultValue: DeviceOrientation = .unknown
}

public extension EnvironmentValues {
    var deviceOrientation: DeviceOrientation {
        get { self[DeviceOrientationEnvironmentKey.self] }
        set { self[DeviceOrientationEnvironmentKey.self] = newValue }
    }
}
