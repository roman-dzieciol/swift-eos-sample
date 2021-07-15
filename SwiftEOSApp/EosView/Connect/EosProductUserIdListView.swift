
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosProductUserIdListView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let productUserIds: [EOS_ProductUserId]

    var body: some View {
        List(productUserIds) { productUserId in
            NavigationLink(eos.connectModel.toString(id: productUserId) ?? "",
                           destination: EosProductUserIdView(eos: eos, productUserId: productUserId))
        }
    }
}

