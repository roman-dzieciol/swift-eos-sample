
import Foundation

struct SwiftEOSLogItem: Identifiable {
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullTime, .withFractionalSeconds]
        return formatter
    }()

    let id: String = UUID().uuidString
    let date: Date = Date()
    var dateString: String {
        Self.dateFormatter.string(from: date)
    }
    let string: String
}

class SwiftEOSEvents: ObservableObject {

    @Published var log: [SwiftEOSLogItem] = []

    func log(_ string: String) {
        log += [SwiftEOSLogItem(string: string)]
    }

    init() {

    }
}
