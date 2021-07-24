
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
            KeyValueText("AccountId:", eos.authModel.toString(id: epicAccountId))

            KeyValueText("Login status:", eos.auth.GetLoginStatus(LocalUserId: epicAccountId).description)

            NavigationLink("Query User Info", destination: EosQueryUserInfoView(eos: eos, localUserId: eos.authModel.localUserId!, targetUserId: epicAccountId))
            NavigationLink("Copy User Info", destination: EosCopyUserInfoView(eos: eos, localUserId: eos.authModel.localUserId!, targetUserId: epicAccountId))

            EosNavigationLink("Logout").awaitResultCode {
                try eos.auth.Logout(LocalUserId: epicAccountId, CompletionDelegate: $0)
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            }
        }
        .navigationTitle("Epic Account Id")
    }
}

extension SwiftEOS_Auth_LogoutCallbackInfo: CallbackInfoWithResult {}
extension SwiftEOS_Achievements_OnQueryDefinitionsCompleteCallbackInfo: CallbackInfoWithResult {}
