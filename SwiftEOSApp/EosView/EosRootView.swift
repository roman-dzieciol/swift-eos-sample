
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosRootView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            NavigationView {
                EosMainView(eos: eos)
                    .navigationTitle("Epic Online Services")
            }

            Divider()
            KeyValueText("Epic - \(eos.authModel.currentStatus.description)", EosEpicAccountId(eos.authModel.localUserId))
                .padding([.horizontal])
            KeyValueText("Product - \(eos.connectModel.currentStatus.description)", EosProductUserId(eos.connectModel.localUserId))
                .padding([.horizontal])
        }
    }
}
