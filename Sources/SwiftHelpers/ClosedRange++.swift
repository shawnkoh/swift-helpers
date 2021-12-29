import Foundation

public extension ClosedRange {
    func clamp(_ value: Bound) -> Bound {
        lowerBound > value ? lowerBound
            : upperBound < value ? upperBound
            : value
    }
}
