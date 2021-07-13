
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosEpicAccountView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let epicAccountId: EOS_EpicAccountId

    var body: some View {

        List {
            KeyValueText("AccountId:", epicAccountId.description)

            KeyValueText("Login status:", eos.auth.GetLoginStatus(LocalUserId: epicAccountId).description)

            NavigationLink("QueryUserInfo", destination: EosQueryUserInfoView(eos: eos, localUserId: eos.localUserId!, targetUserId: epicAccountId))
            NavigationLink("CopyUserInfo", destination: EosCopyUserInfoView(eos: eos, localUserId: eos.localUserId!, targetUserId: epicAccountId))

            NavigationLink("Logout", destination: EosResultView("Logout") {
                try eos.auth.Logout(LocalUserId: epicAccountId, CompletionDelegate: $0)
            })
        }
        .navigationTitle("Epic Account Id")
    }
}

extension SwiftEOS_Auth_LogoutCallbackInfo: CallbackInfoWithResult {}
