
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK

struct EosUserInfoView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let userInfo: SwiftEOS_UserInfo

    var body: some View {
        List {
            KeyValueText("UserId:", eos.authModel.toString(id: userInfo.UserId))
            KeyValueText("Country:", userInfo.Country)
            KeyValueText("DisplayName:", userInfo.DisplayName)
            KeyValueText("PreferredLanguage:", userInfo.PreferredLanguage)
            KeyValueText("Nickname:", userInfo.Nickname)
        }
        .navigationTitle("UserInfo")
    }
}
