
import Foundation
import SwiftUI
import SwiftEOS

struct EosAuthTokenView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let token: SwiftEOS_Auth_Token

    var body: some View {

        List {

            Group {
                NavigationLink(destination: EosVerifyUserAuthView(eos: eos, token: token)) { Text("Verify") }
                Text("App: \(token.App ?? "")")
                Text("ClientId: \(token.ClientId ?? "")")
                NavigationLink(destination: EosEpicAccountView(eos: eos, account: token.AccountId!)) { Text("AccountId: \(token.AccountId!.description)") }
            }

            Group {
                Text("AccessToken: \(token.AccessToken ?? "")")
                Text("ExpiresIn: \(token.ExpiresIn)")
                Text("ExpiresAt: \(token.ExpiresAt ?? "")")
                Text("AuthType: \(token.AuthType.description)")
            }

            Group {
                Text("RefreshToken: \(token.RefreshToken ?? "")")
                Text("RefreshExpiresIn: " + "\(token.RefreshExpiresIn)")
                Text("RefreshExpiresAt: " + (token.RefreshExpiresAt ?? ""))
            }

        }
        .navigationTitle("Auth Token")
    }
}
