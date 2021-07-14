
import SwiftUI

struct KeyValueText: View {

    struct VerifiedText {
        let text: String
        let leadingSpace: String
        let trimmedText: String
        let trailingSpace: String

        var isEmpty: Bool {
            text.isEmpty
        }

        var hasWhitespace: Bool {
            !leadingSpace.isEmpty || !trailingSpace.isEmpty
        }

        init(text: String) {
            self.text = text
            leadingSpace = String(text.prefix(while: { $0.isWhitespace }))
            trailingSpace = String(text.reversed().prefix(while: { $0.isWhitespace }).reversed())
            trimmedText = String(text.dropFirst(leadingSpace.count).dropLast(trailingSpace.count))
        }
    }

    let key: String
    let value: VerifiedText?

    init(_ key: String, _ value: String?) {
        self.key = key
        self.value = value.map { VerifiedText(text: $0) }
    }

    @ViewBuilder var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(key)
                .font(.footnote)
                .foregroundColor(.eosSecondary)

            if let value = value {

                if !value.isEmpty {
                    Text(value.hasWhitespace ? "\"" : "")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.red)

                    + Text(value.text)
                        .font(.system(.body, design: .monospaced))
                        .underline(value.hasWhitespace, color: Color.red)

                    + Text(value.hasWhitespace ? "\"" : "")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.red)
                } else {
                    Text("<Empty String>")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.red)
                }
            } else {
                Text("<NULL>")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.red)
            }
        }
        .contextMenu {
            Button(action: {
                UIPasteboard.general.string = value?.text
            }) {
                Text("Copy")
            }
        }
    }
}


struct KeyValueTextField: View {

    let key: String

    @Binding
    var value: String

    init(_ key: String, _ value: Binding<String>) {
        self.key = key
        _value = value
    }

    @ViewBuilder var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(key)
                .font(.footnote)
                .foregroundColor(.eosSecondary)

            TextField(key, text: $value)
                .font(.system(.body, design: .monospaced))
                .textFieldStyle(.roundedBorder)
        }
    }
}

