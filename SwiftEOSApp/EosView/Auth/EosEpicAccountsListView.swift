
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosEpicAccountsListView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let epicAccountIds: [EOS_EpicAccountId]

    var body: some View {
        if epicAccountIds.isEmpty {
            Text("<Empty List>")
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.red)
        } else {
            List(epicAccountIds) { epicAccountId in
                NavigationLink(EosEpicAccountId(epicAccountId).description, destination: EosEpicAccountView(eos: eos, epicAccountId: epicAccountId))
            }
        }
    }
}

