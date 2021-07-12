
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
                KeyValueText("App:", token.App)
                KeyValueText("ClientId:", token.ClientId)
                NavigationLink(destination: EosEpicAccountView(eos: eos, account: token.AccountId!)) {
                    KeyValueText("AccountId:", token.AccountId?.description)
                }
            }

            Group {
                KeyValueText("AccessToken:", token.AccessToken)
                KeyValueText("ExpiresIn:", "\(token.ExpiresIn)")
                KeyValueText("ExpiresAt:", token.ExpiresAt)
                KeyValueText("AuthType:", token.AuthType.description)
            }

            Group {
                KeyValueText("RefreshToken:", token.RefreshToken)
                KeyValueText("RefreshExpiresIn:", "\(token.RefreshExpiresIn)")
                KeyValueText("RefreshExpiresAt:", token.RefreshExpiresAt)
            }

        }
        .navigationTitle("Auth Token")
    }
}
