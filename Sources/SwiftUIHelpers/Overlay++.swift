import SwiftUI

extension View {
    @_disfavoredOverload
    @inlinable
    func overlay<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V: View {
        overlay(content(), alignment: alignment)
    }
}
