
import SwiftUI


struct EosLoadingView<Item, Content>: View where Content : View {

    @State
    var result: Item? = nil

    var load: (@escaping (Item) -> Void) throws -> Void
    var builder: (Item) throws -> Content

    public init(load: @escaping (@escaping (Item) -> Void) throws -> Void, @ViewBuilder builder: @escaping (Item) throws -> Content) {
        self.load = load
        self.builder = builder
    }

    var body: some View {

        if let result = result {
            try! builder(result)
        } else {
            ProgressView()
                .onAppear {
                    try! load { result in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.result = result
                        }
                    }
                }
        }
    }
}
