
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosProductUserIdView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let productUserId: EOS_ProductUserId

    var body: some View {
        List {
            KeyValueText("ProductUserId:", eos.connectModel.toString(id: productUserId))

            EosNavigationLink("Copy Product User Info").result {
                try eos.connect.CopyProductUserInfo(TargetUserId: productUserId)
            } views: {
                EosProductUserInfoView(eos: eos, info: $0)
            }
        }
        .navigationTitle("Product User Id")
    }
}
