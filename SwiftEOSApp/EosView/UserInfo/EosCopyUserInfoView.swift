
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
            KeyValueText("Local:", localUserId.description)
            KeyValueText("Target:", targetUserId.description)
            NavigationLink("Copy User Info", destination: EosCheckedView("Copy User Info") {
                try eos.userInfo.CopyUserInfo(LocalUserId: localUserId, TargetUserId: localUserId)
            } views: {
                EosUserInfoView(eos: eos, userInfo: $0)
            })
        }
        .navigationTitle("CopyUserInfo")
    }
}