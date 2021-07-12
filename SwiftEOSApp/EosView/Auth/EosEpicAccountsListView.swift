

import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK

struct EosEpicAccountsListView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let epicAccountIds: [EOS_EpicAccountId]

    var body: some View {
        List(epicAccountIds) { epicAccountId in
            NavigationLink(epicAccountId.description, destination: EosEpicAccountView(eos: eos, epicAccountId: epicAccountId))
        }
    }
}

