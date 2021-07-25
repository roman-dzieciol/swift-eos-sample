
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosListView<Item: Identifiable, ViewType: View>: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let items: [Item]
    let views: (SwiftEOSModel, Item) -> ViewType

    init(eos: SwiftEOSModel, items: [Item], @ViewBuilder views: @escaping (SwiftEOSModel, Item) -> ViewType) {
        self.eos = eos
        self.items = items
        self.views = views
    }

    var body: some View {
        if items.isEmpty {
            Text("<Empty List>")
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.red)
        } else {
            List(items) { item in
                EosNavigationLink("\(item.id)").view {
                    views(eos, item)
                }
            }
        }
    }
}
