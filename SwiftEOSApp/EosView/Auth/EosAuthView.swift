
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

            NavigationLink("Login (Automatic)", destination: EosLoadingView("Login (Automatic)") { completion in
                try eos.authModel.login { completion($0) }
            } views: {
                Text("Logged in")
            })

            NavigationLink("Login (Persistent)", destination: EosLoadingView("Login (Persistent)") { completion in
                try eos.authModel.loginPersistent { completion($0) }
            } views: {
                Text("Logged in")
            })

            NavigationLink("Login (Portal)", destination: EosLoadingView("Login (Portal)") { completion in
                try eos.authModel.loginThroughPortal { completion($0) }
            } views: {
                Text("Logged in")
            })

            NavigationLink("Delete Persistent Auth", destination: EosResultView("Delete Persistent Auth") {
                try eos.auth.DeletePersistentAuth(RefreshToken: nil, CompletionDelegate: $0)
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            })

            NavigationLink("Get Logged In Accounts", destination: EosCheckedView("Get Logged In Accounts") {
                let accountsNum = try eos.auth.GetLoggedInAccountsCount()
                return try (0..<accountsNum).compactMap { try eos.auth.GetLoggedInAccountByIndex(Index: $0) }
            } views: {
                EosEpicAccountsListView(eos: eos, epicAccountIds: $0)
            })

            if let localUserId = authModel.localUserId {

                NavigationLink("Copy User Auth Token", destination: EosCheckedView("Copy User Auth Token") {
                    try eos.auth.CopyUserAuthToken(LocalUserId: localUserId)
                } views: {
                    EosAuthTokenView(eos: eos, token: $0)
                })

                NavigationLink("Query User Info", destination: EosResultView("Query User Info") {
                    try eos.userInfo.QueryUserInfo(LocalUserId: localUserId, TargetUserId: localUserId, CompletionDelegate: $0)
                } views: {
                    KeyValueText("Result:", $0.ResultCode.description)
                })

                NavigationLink("Copy User Info", destination: EosCheckedView("Copy User Info") {
                    try eos.userInfo.CopyUserInfo(LocalUserId: localUserId, TargetUserId: localUserId)
                } views: {
                    EosUserInfoView(eos: eos, userInfo: $0)
                })

                NavigationLink("Logout", destination: EosResultView("Logout") {
                    try eos.auth.Logout(LocalUserId: localUserId, CompletionDelegate: $0)
                } views: {
                    KeyValueText("Result:", $0.ResultCode.description)
                })
            }
        }
    }
}

extension SwiftEOS_Auth_DeletePersistentAuthCallbackInfo: CallbackInfoWithResult {}
