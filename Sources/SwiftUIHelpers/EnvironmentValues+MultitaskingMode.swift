import SwiftUI

public enum MultitaskingMode {
    case oneThird
    case half
    case twoThirds
    case full

    public var value: Double {
        switch self {
        case .oneThird:
            return 1.0 / 3.0
        case .twoThirds:
            return 2.0 / 3.0
        case .half:
            return 1.0 / 2.0
        case .full:
            return 1
        }
    }
}

private struct MultitaskingModeEnvironmentKey: EnvironmentKey {
    static let defaultValue: MultitaskingMode = .full
}

public extension EnvironmentValues {
    var multitaskingMode: MultitaskingMode {
        get { self[MultitaskingModeEnvironmentKey.self] }
        set { self[MultitaskingModeEnvironmentKey.self] = newValue }
    }
}
