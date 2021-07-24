
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosAuthView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let authModel: EosAuthModel

    var body: some View {

        List {

            EosNavigationLink("Login (Automatic)").awaitResult { completion in
                try eos.authModel.login { completion($0) }
            } views: {
                Text("Logged in")
            }

            EosNavigationLink("Login (Persistent)").awaitResult { completion in
                try eos.authModel.loginPersistent { completion($0) }
            } views: {
                Text("Logged in")
            }

            EosNavigationLink("Login (Portal)").awaitResult { completion in
                try eos.authModel.loginThroughPortal { completion($0) }
            } views: {
                Text("Logged in")
            }

            EosNavigationLink("Delete Persistent Auth").awaitResultCode {
                try eos.auth.DeletePersistentAuth(RefreshToken: nil, CompletionDelegate: $0)
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            }

            EosNavigationLink("Get Logged In Accounts").result {
                let accountsNum = try eos.auth.GetLoggedInAccountsCount()
                return try (0..<accountsNum).compactMap { try eos.auth.GetLoggedInAccountByIndex(Index: $0) }
            } views: {
                EosEpicAccountsListView(eos: eos, epicAccountIds: $0)
            }

            if let localUserId = authModel.localUserId {

                EosNavigationLink("Copy User Auth Token").result {
                    try eos.auth.CopyUserAuthToken(LocalUserId: localUserId)
                } views: {
                    EosAuthTokenView(eos: eos, token: $0)
                }

                EosNavigationLink("Query User Info").awaitResultCode {
                    try eos.userInfo.QueryUserInfo(LocalUserId: localUserId, TargetUserId: localUserId, CompletionDelegate: $0)
                } views: {
                    KeyValueText("Result:", $0.ResultCode.description)
                }

                EosNavigationLink("Copy User Info").result {
                    try eos.userInfo.CopyUserInfo(LocalUserId: localUserId, TargetUserId: localUserId)
                } views: {
                    EosUserInfoView(eos: eos, userInfo: $0)
                }

                EosNavigationLink("Logout").awaitResultCode {
                    try eos.auth.Logout(LocalUserId: localUserId, CompletionDelegate: $0)
                } views: {
                    KeyValueText("Result:", $0.ResultCode.description)
                }
            }
        }
    }
}

extension SwiftEOS_Auth_DeletePersistentAuthCallbackInfo: CallbackInfoWithResult {}
