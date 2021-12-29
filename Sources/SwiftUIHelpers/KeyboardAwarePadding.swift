import Combine
import SwiftUI

// Credit: https://stackoverflow.com/questions/57746006/how-to-get-the-keyboard-height-on-multiple-screens-with-swiftui-and-move-the-but
struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: Double = 0

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
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { height in
                keyboardHeight = height
            }
    }
}

extension View {
    func keyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}
