import Foundation
import SwiftUI

public extension Image {
    /// Initializes and returns the image with the specified data.
    init?(data: Data) {
        #if os(macOS)
            let image = NSImage(data: data)
        #else
            let image = UIImage(data: data)
        #endif

        guard let _image = image else {
            return nil
        }

        #if os(macOS)
            self.init(nsImage: _image)
        #else
            self.init(uiImage: _image)
        #endif
    }
}
