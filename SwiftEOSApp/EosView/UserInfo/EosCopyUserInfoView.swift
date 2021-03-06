
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosCopyUserInfoView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let localUserId: EOS_EpicAccountId

    let targetUserId: EOS_EpicAccountId

    var body: some View {
        List {
            KeyValueText("Local:", EosEpicAccountId(localUserId))
            KeyValueText("Target:", EosEpicAccountId(targetUserId))
            EosNavigationLink("Copy User Info").result {
                try eos.userInfo.CopyUserInfo(LocalUserId: localUserId, TargetUserId: localUserId)
            } views: {
                EosUserInfoView(eos: eos, userInfo: $0)
            }
        }
        .navigationTitle("CopyUserInfo")
    }
}
