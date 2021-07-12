
import SwiftUI

struct KeyValueText: View {

    let key: String
    let value: String?

    init(_ key: String, _ value: String?) {
        self.key = key
        self.value = value
    }

    @ViewBuilder var body: some View {
        (
            Text(key)
                .font(.callout)
                .foregroundColor(.secondary)
            + Text(" ")
            + Text(value ?? "")
        ).contextMenu {
            Button(action: {
                UIPasteboard.general.string = value ?? ""
            }) {
                Text("Copy")
            }
        }
    }
}

