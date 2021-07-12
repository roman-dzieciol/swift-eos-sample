
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosLoggedInView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let localUserId: EOS_EpicAccountId

    var body: some View {

        List {
            NavigationLink("Auth", destination: EosAuthView(eos: eos, localUserId: localUserId))
                .navigationTitle("Auth")
        }
        .navigationTitle(" \(eos.auth.GetLoginStatus(LocalUserId: localUserId).description)")
    }
}
