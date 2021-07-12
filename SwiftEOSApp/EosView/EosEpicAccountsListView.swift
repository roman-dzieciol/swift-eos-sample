

import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK

struct EosEpicAccountsListView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let accounts: [EOS_EpicAccountId]

    var body: some View {

        List(accounts) { account in
            NavigationLink(destination: EosEpicAccountView(eos: eos, account: account), label: { Text("\(account.description)") })
        }
        .navigationTitle("Epic Account Ids")

    }
}

