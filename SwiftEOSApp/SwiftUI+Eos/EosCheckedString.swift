
import Foundation

protocol EosCheckedStringConvertible {
    func toString() throws -> String?
}

struct EosCheckedString: Equatable, CustomStringConvertible {

    enum State {
        case string
        case empty
        case null
        case error
    }

    let string: String
    let state: State

    var description: String {
        string
    }

    var hasSpaces: Bool {
        return string.first?.isWhitespace == true || string.last?.isWhitespace == true
    }

    init(_ string: @autoclosure () throws -> String?) {
        do {
            if let string = try string() {
                if !string.isEmpty {
                    self.string = string
                    self.state = .string
                } else {
                    self.string = "<Empty String>"
                    self.state = .empty
                }
            } else {
                self.string = "<NULL>"
                self.state = .null
            }
        } catch {
            self.string = "<Error: \(error)>"
            self.state = .error
        }
    }
}
