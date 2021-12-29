import SwiftUI

public struct ColorStepper<V: CustomStringConvertible & Strideable>: View {
    @Binding var value: V
    let bounds: ClosedRange<V>
    let step: V.Stride

    public init(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1) {
        _value = value
        self.bounds = bounds
        self.step = step
    }

    public var body: some View {
        HStack {
            Button(action: { value = value.advanced(by: -step) }) {
                Image("stepper-subtract")
            }
            .frame(width: 30, height: 30)
            .opacity(value == bounds.lowerBound ? 0.2 : 1)
            .disabled(value == bounds.lowerBound)

            Spacer()

            Text(value.description)
                .fixedSize()

            Spacer()

            Button(action: { value = value.advanced(by: step) }) {
                Image("stepper-add")
            }
            .opacity(value == bounds.upperBound ? 0.2 : 1)
            .disabled(value == bounds.upperBound)
            .frame(width: 30, height: 30)
        }
    }
}

struct ColorStepper_Previews: PreviewProvider {
    @State static var hue: Double = 0

    static var previews: some View {
        ColorStepper(value: $hue, in: 0 ... 360)
    }
}
