
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosQueryUserInfoView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let localUserId: EOS_EpicAccountId

    let targetUserId: EOS_EpicAccountId

    var body: some View {
        List {
            KeyValueText("Local:", localUserId.description)
            KeyValueText("Target:", targetUserId.description)
            NavigationLink("Query User Info", destination: EosResultView("Query User Info") {
                try eos.userInfo.QueryUserInfo(LocalUserId: localUserId, TargetUserId: targetUserId, CompletionDelegate: $0)
            })
        }
        .navigationTitle("Query User Info")
    }
}

extension SwiftEOS_UserInfo_QueryUserInfoCallbackInfo: CallbackInfoWithResult {}
