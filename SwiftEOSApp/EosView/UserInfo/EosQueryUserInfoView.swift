
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
            KeyValueText("Local:", EosEpicAccountId(localUserId))
            KeyValueText("Target:", EosEpicAccountId(targetUserId))
            EosNavigationLink("Query User Info").awaitResultCode {
                try eos.userInfo.QueryUserInfo(LocalUserId: localUserId, TargetUserId: targetUserId, CompletionDelegate: $0)
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            }
        }
        .navigationTitle("Query User Info")
    }
}

extension SwiftEOS_UserInfo_QueryUserInfoCallbackInfo: CallbackInfoWithResult {}
