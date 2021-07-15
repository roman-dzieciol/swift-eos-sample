
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosAuthTokenView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let token: SwiftEOS_Auth_Token

    var body: some View {
        List {
            Group {
                NavigationLink("Verify", destination: EosResultView("Verify") {
                    try eos.auth.VerifyUserAuth(AuthToken: token, CompletionDelegate: $0)
                } views: {
                    KeyValueText("Result:", $0.ResultCode.description)
                })
                KeyValueText("App:", token.App)
                KeyValueText("ClientId:", token.ClientId)
                NavigationLink(destination: EosEpicAccountView(eos: eos, epicAccountId: token.AccountId!)) {
                    KeyValueText("AccountId:", eos.authModel.toString(id: token.AccountId))
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
    }
}

extension SwiftEOS_Auth_VerifyUserAuthCallbackInfo: CallbackInfoWithResult {}
