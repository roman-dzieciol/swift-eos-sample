
import SwiftUI

extension Text {

    public static func copyable(_ text: String) -> some View {
        return Text(text)
            .contextMenu {
                Button(action: {
                    UIPasteboard.general.string = text
                }) {
                    Text("Copy")
                }
            }
    }
}

