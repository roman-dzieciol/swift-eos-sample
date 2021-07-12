
import Foundation
import SwiftUI
import EOSSDK
import SwiftEOS

struct EosVerifyUserAuthView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let token: SwiftEOS_Auth_Token

    var body: some View {

        EosLoadingView { completion in
            try eos.auth.VerifyUserAuth(AuthToken: token) { info in
                completion(info)
            }
        } builder: { result in
            Text(result.ResultCode.description)
        }
    }
}


