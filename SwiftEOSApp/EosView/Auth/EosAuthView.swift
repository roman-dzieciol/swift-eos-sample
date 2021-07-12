
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosAuthView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let localUserId: EOS_EpicAccountId

    var body: some View {

        List {
            KeyValueText("LocalUserId:", localUserId.description)

            NavigationLink("Get Logged In Accounts", destination: EosCheckedView("Get Logged In Accounts") {
                let accountsNum = try eos.auth.GetLoggedInAccountsCount()
                return try (0..<accountsNum).map { try eos.auth.GetLoggedInAccountByIndex(Index: $0) }
            } views: {
                EosEpicAccountsListView(eos: eos, epicAccountIds: $0)
            })

            NavigationLink("Copy User Auth Token", destination: EosCheckedView("Copy User Auth Token") {
                try eos.auth.CopyUserAuthToken(LocalUserId: localUserId)
            } views: {
                EosAuthTokenView(eos: eos, token: $0)
            })

            NavigationLink("Query User Info", destination: EosResultView("Query User Info") {
                try eos.userInfo.QueryUserInfo(LocalUserId: eos.localUserId!, TargetUserId: localUserId, CompletionDelegate: $0)
            })

            NavigationLink("Copy User Info", destination: EosCheckedView("Copy User Info") {
                try eos.userInfo.CopyUserInfo(LocalUserId: localUserId, TargetUserId: localUserId)
            } views: {
                EosUserInfoView(eos: eos, userInfo: $0)
            })

            NavigationLink("Delete Persistent Auth", destination: EosResultView("Delete Persistent Auth") {
                try eos.auth.DeletePersistentAuth(RefreshToken: nil, CompletionDelegate: $0)
            })

            NavigationLink("Logout", destination: EosResultView("Logout") {
                try eos.auth.Logout(LocalUserId: localUserId, CompletionDelegate: $0)
            })
        }
    }
}

extension SwiftEOS_Auth_DeletePersistentAuthCallbackInfo: CallbackInfoWithResult {}
