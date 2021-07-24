
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosProductUserInfoView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let info: SwiftEOS_Connect_ExternalAccountInfo

    var body: some View {
        List {
            KeyValueText("ProductUserId:", EosProductUserId(info.ProductUserId))
            KeyValueText("DisplayName:", info.DisplayName)
            KeyValueText("AccountId:", info.AccountId)
            KeyValueText("AccountIdType:", info.AccountIdType.description)
            KeyValueText("LastLoginTime:", "\(info.LastLoginTime)")
        }
    }
}
