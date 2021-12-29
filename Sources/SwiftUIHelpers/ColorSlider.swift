import SwiftHelpers
import SwiftUI

public struct ColorSlider: View {
    @Binding var value: Int
    let bounds: ClosedRange<Int>
    let step: Int
    let colorMap: (Int) -> SwiftUI.Color
    let onChanged: (() -> Void)?
    let onEnded: (() -> Void)?

    public init(
        value: Binding<Int>,
        bounds: ClosedRange<Int>,
        step: Int,
        colorMap: @escaping (Int) -> SwiftUI.Color,
        onChanged: (() -> Void)?,
        onEnded: (() -> Void)?
    ) {
        _value = value
        self.bounds = bounds
        self.step = step
        self.colorMap = colorMap
        self.onChanged = onChanged
        self.onEnded = onEnded
    }

    private var colors: [SwiftUI.Color] {
        stride(from: bounds.lowerBound, to: bounds.upperBound, by: step)
            .map(colorMap)
    }

    @State private var currentDistanceMoved: Double = 0

    private var percentage: Double {
        Double(value) / Double(bounds.upperBound - bounds.lowerBound)
    }

    public var body: some View {
        GeometryReader { proxy in
            let gesture = DragGesture(minimumDistance: 10, coordinateSpace: .global)
                .onChanged { gesture in
                    let range = Double(bounds.upperBound - bounds.lowerBound)
                    let stepCount = range / Double(step)
                    let distancePerStep = proxy.size.width / stepCount
                    let movedDistance = gesture.translation.width - currentDistanceMoved
                    currentDistanceMoved = gesture.translation.width
                    let stepDelta = (movedDistance / distancePerStep).rounded()
                    value = bounds.clamp(value + Int(stepDelta))
                    onChanged?()
                }
                .onEnded { _ in
                    currentDistanceMoved = 0
                    onEnded?()
                }

            VStack {
                Spacer()
                LinearGradient(
                    gradient: .init(colors: colors),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 6)
                .cornerRadius(25)
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(SwiftUI.Color.clear)
                        .frame(width: 6, height: 6)
                        .overlay(
                            Image("color-slider-handle")
                                .frame(width: 30, height: 30)
                        )
                        .offset(x: percentage * (proxy.size.width - 6))
                        .gesture(gesture)
                }
                Spacer()
            }
        }
    }
}

struct ColorSlider_Previews: PreviewProvider {
    @State static var hue = 1
    static let color = SwiftUI.Color.white

    static var previews: some View {
        ColorSlider(value: $hue, bounds: 0 ... 360, step: 1, colorMap: {
            color.opacity(Double($0))
        }, onChanged: nil, onEnded: nil)
    }
}
