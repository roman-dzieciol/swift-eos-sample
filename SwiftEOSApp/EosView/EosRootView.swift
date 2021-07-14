
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
            KeyValueText("Epic - \(eos.authModel.currentStatus.description)", eos.authModel.toString(id: eos.authModel.localUserId))
                .padding([.horizontal])
            KeyValueText("Product - \(eos.connectModel.currentStatus.description)", eos.connectModel.toString(id: eos.connectModel.localUserId))
                .padding([.horizontal])
        }
    }
}
