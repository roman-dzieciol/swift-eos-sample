
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosMainView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    @State
    var isLoggingIn: Bool = false

    var body: some View {

        List {
            NavigationLink("Auth", destination: EosAuthView(eos: eos, authModel: eos.authModel).navigationTitle("Auth"))

            NavigationLink("Connect", destination: EosConnectView(eos: eos, connectModel: eos.connectModel).navigationTitle("Connect"))

            NavigationLink("Achievements", destination: EosAchievementsView(eos: eos).navigationTitle("Achievements"))

            if !eos.authModel.isLoggedIn {
                if !isLoggingIn {
                    Button("Login All") {
                        self.isLoggingIn = true
                        try? eos.authModel.login { _ in
                            try? eos.connectModel.loginDevice { _ in
                                self.isLoggingIn = false
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
        }
    }
}
