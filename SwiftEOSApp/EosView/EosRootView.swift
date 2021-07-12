
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosRootView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    var body: some View {

        if eos.isLoggedIn, let localUserId = eos.localUserId {
            NavigationView {
                EosLoggedInView(eos: eos, localUserId: localUserId)
            }
        }
        else {
            NavigationView {
                EosLoginView(eos: eos)
                    .navigationTitle("Epic Online Services")
            }
        }
    }
}
