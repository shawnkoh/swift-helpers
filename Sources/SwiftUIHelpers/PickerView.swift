import SwiftUI
import UIKit

public class InlinePickerViewCoordinator<Row: Equatable, Content: View>: NSObject, UIPickerViewDataSource,
    UIPickerViewDelegate
{
    let parent: InlinePickerView<Row, Content>
    private var selectionIndicatorHeightAnchor: NSLayoutConstraint?
    public init(_ parent: InlinePickerView<Row, Content>) {
        self.parent = parent
    }

    // MARK: UIPickerViewDataSource

    public func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    public func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        parent.rows.count
    }

    // MARK: UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent _: Int,
                           reusing _: UIView?) -> UIView
    {
        if selectionIndicatorHeightAnchor == nil, pickerView.subviews.count == 2,
           let indicator = pickerView.subviews.last
        {
            let heightAnchor = indicator.heightAnchor.constraint(equalToConstant: parent.selectionIndicatorHeight)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                indicator.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor),
                indicator.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor),
                indicator.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor),
                heightAnchor,
            ])
            selectionIndicatorHeightAnchor = heightAnchor
        }
        let row = parent.rows[row]
        let viewController = UIHostingController(rootView: parent.builder(row))
        viewController.view.backgroundColor = .clear
        return viewController.view
    }

    public func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        parent.currentRow = parent.rows[row]
    }
}

public struct InlinePickerView<Row: Equatable, Content: View>: UIViewRepresentable {
    public typealias Coordinator = InlinePickerViewCoordinator<Row, Content>
    public var rows: [Row]
    @Binding public var currentRow: Row
    public let selectionIndicatorHeight: Double
    @ViewBuilder let builder: (Row) -> Content

    public init(
        rows: [Row],
        currentRow: Binding<Row>,
        selectionIndicatorHeight: Double,
        @ViewBuilder builder: @escaping (Row) -> Content
    ) {
        self.rows = rows
        _currentRow = currentRow
        self.selectionIndicatorHeight = selectionIndicatorHeight
        self.builder = builder
    }

    public func makeCoordinator() -> Coordinator {
        InlinePickerViewCoordinator(self)
    }

    public func makeUIView(context: Context) -> UIPickerView {
        let view = UIPickerView()
        // This was the critical fix for iOS 15.1's Picker regression.
        // Seems like they updated the stack view compression logic silently.
        // https://useyourloaf.com/blog/stack-view-changes-in-ios-15/
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.dataSource = context.coordinator
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: UIPickerView, context _: Context) {
        // TODO: This only works because opacities doesn't change.
        // It needs to be smarter.
        guard let index = rows.firstIndex(of: currentRow), uiView.selectedRow(inComponent: 0) != index else {
            return
        }
        uiView.selectRow(index, inComponent: 0, animated: true)
    }
}
