
import SwiftUI

struct KeyValueText: View {

    let key: String
    let value: EosCheckedString

    init(_ key: String, _ value: EosCheckedStringConvertible) {
        self.init(key, { try value.toString() })
    }

    init(_ key: String, _ value: String?) {
        self.init(key, { value })
    }

    init(_ key: String, _ value: () throws -> String?) {
        self.key = key
        self.value = EosCheckedString(try value())
    }

    @ViewBuilder var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(key)
                .font(.footnote)
                .foregroundColor(.eosSecondary)

            switch value.state {
            case .string:
                Text(value.hasSpaces ? "\"" : "")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.red)

                + Text(value.string)
                    .font(.system(.body, design: .monospaced))
                    .underline(value.hasSpaces, color: Color.red)

                + Text(value.hasSpaces ? "\"" : "")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.red)

            case .empty, .null, .error:
                Text(value.string)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.red)
            }
        }
        .contextMenu {
            Button(action: {
                UIPasteboard.general.string = value.string
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

    @State
    var isValid: Bool? = nil

    let onValidate: (String) -> Bool

    var validatedColor: Color {
        if isValid == true {
            return .eosPrimary
        } else if isValid == false {
            return .red
        } else {
            return .eosSecondary
        }
    }

    init(_ key: String, _ value: Binding<String>, onValidate: @escaping (String) throws -> Bool = { _ in true }) {
        self.key = key
        self.onValidate = { value in
            return (try? onValidate(value)) == true
        }
        _value = value
    }

    @ViewBuilder var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(key)
                .font(.footnote)
                .foregroundColor(.eosSecondary)

            TextField(key, text: $value, onCommit: {
                isValid = onValidate(value)
            })
                .font(.system(.body, design: .monospaced))
                .textFieldStyle(.roundedBorder)
                .foregroundColor(validatedColor)
        }
    }
}

