import Combine
import SwiftUI

struct KeyboardAwareOverlay<Overlay: View>: ViewModifier {
    @State private var keyboardOffset: Double = 0
    @State private var isCentered = true
    let physicalKeyboardThreshold: Double = 100

    let offset: Double
    let overlay: Overlay

    private var keyboardHeightPublisher: AnyPublisher<Double, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map(\.cgRectValue.height)
                .map(Double.init),
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in Double(0) }
        ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .overlay(alignment: isCentered ? .center : .bottom) {
                overlay
                    .offset(y: -keyboardOffset)
            }
            .onReceive(keyboardHeightPublisher) { height in
                withAnimation {
                    guard height != 0, height > physicalKeyboardThreshold else {
                        isCentered = true
                        keyboardOffset = 0
                        return
                    }

                    isCentered = false
                    keyboardOffset = height + offset
                }
            }
    }
}

public extension View {
    func keyboardAwareOverlay<Overlay: View>(offset: Double, @ViewBuilder _ overlay: () -> Overlay) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareOverlay(offset: offset, overlay: overlay()))
    }
}
