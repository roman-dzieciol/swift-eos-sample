
import Foundation
import SwiftEOS
import EOSSDK
import os.log

struct EosProductUserId: CustomStringConvertible, EosCheckedStringConvertible {

    let id: EOS_ProductUserId?

    var description: String {
        EosCheckedString(try toString()).description
    }

    func toString() throws -> String? {
        guard let id = id else { return nil }
        return try throwingNilResult { try SwiftEOS_ProductUserId_ToString(AccountId: id) }
    }

    init(_ id: EOS_ProductUserId?) {
        self.id = id
    }
}
