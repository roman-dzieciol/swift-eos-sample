

import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosEpicAccountView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let account: EOS_EpicAccountId

    var body: some View {

        List {
            KeyValueText("AccountId:", account.description)

            KeyValueText("Login status:", eos.auth.GetLoginStatus(LocalUserId: account).description)

            NavigationLink(destination: EosLoadingView { completion in
                try eos.auth.Logout(LocalUserId: account) { info in
                    completion(info)
                }
            } builder: { result in
                Text.copyable(result.ResultCode.description)
            }, label: { Text("Logout") })

        }
        .navigationTitle("Epic Account Id")
    }
}

