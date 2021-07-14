
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosMainView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    var body: some View {

        List {
            NavigationLink("Auth", destination: EosAuthView(eos: eos, authModel: eos.authModel).navigationTitle("Auth"))

            NavigationLink("Connect", destination: EosConnectView(eos: eos, connectModel: eos.connectModel).navigationTitle("Connect"))

            NavigationLink("Achievements", destination: EosAchievementsView(eos: eos).navigationTitle("Achievements"))
        }
    }
}
