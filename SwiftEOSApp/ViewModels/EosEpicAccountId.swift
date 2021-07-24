
import Foundation
import SwiftEOS
import EOSSDK
import os.log

struct EosEpicAccountId: CustomStringConvertible, EosCheckedStringConvertible {

    let id: EOS_EpicAccountId?

    var description: String {
        EosCheckedString(try toString()).description
    }

    func toString() throws -> String? {
        guard let id = id else { return nil }
        return try throwingNilResult { try SwiftEOS_EpicAccountId_ToString(AccountId: id) }
    }

    init(_ id: EOS_EpicAccountId?) {
        self.id = id
    }
}
