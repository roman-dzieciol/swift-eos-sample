
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

            if let accountsNum = try? eos.auth.GetLoggedInAccountsCount() {
                NavigationLink(
                    destination: EosEpicAccountsListView(
                        eos: eos,
                        accounts: (try? (0..<accountsNum).map { try eos.platform.auth().GetLoggedInAccountByIndex(Index: $0) }) ?? [] ),
                    label: { Text("Logged in accounts: \(accountsNum)") }
                )
            }

            if let token = try? eos.platform.auth().CopyUserAuthToken(LocalUserId: localUserId) {
                NavigationLink(destination: EosAuthTokenView(eos: eos, token: token), label: { Text("Auth Token") })

                if let account = token.AccountId {
                    NavigationLink(destination: EosLoadingView { completion in
                        try eos.auth.Logout(LocalUserId: account) { info in
                            completion(info)
                        }
                    } builder: { (result: SwiftEOS_Auth_LogoutCallbackInfo) in
                        Text(result.ResultCode.description)
                    }, label: { Text("Logout") })
                }
            }

            NavigationLink(destination: EosLoadingView { completion in
                try eos.auth.DeletePersistentAuth(RefreshToken: nil) { info in
                    completion(info)
                }
            } builder: { result in
                Text(result.ResultCode.description)
            }, label: { Text("Delete persistent auth") })


        }
        .navigationTitle("Auth")

    }
}
