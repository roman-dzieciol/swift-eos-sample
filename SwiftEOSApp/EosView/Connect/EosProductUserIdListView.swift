
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosProductUserIdListView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let productUserIds: [EOS_ProductUserId]

    var body: some View {
        if productUserIds.isEmpty {
            Text("<Empty List>")
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.red)
        } else {
            List(productUserIds) { productUserId in
                NavigationLink(EosProductUserId(productUserId).description,
                               destination: EosProductUserIdView(eos: eos, productUserId: productUserId))
            }
        }
    }
}

