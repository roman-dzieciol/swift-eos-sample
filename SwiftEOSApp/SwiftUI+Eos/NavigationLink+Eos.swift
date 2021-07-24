
import SwiftUI

extension View {

    func navigationLink(_ title: String) -> some View {
        NavigationLink(title, destination: self.navigationTitle(title))
    }
}

struct EosNavigationLink {

    let navigationTitle: String

    init(_ navigationTitle: String) {
        self.navigationTitle = navigationTitle
    }

    func result<Value, BuilderView: View>(
        _ call: @escaping () throws -> Value,
        views:  @escaping (Value) -> BuilderView
    ) -> some View {
        NavigationLink(navigationTitle, destination: EosCompletionView.result(navigationTitle, call, views: views))
    }

    func awaitResult<Value, BuilderView: View>(
        _ call: @escaping (@escaping (Result<Value, Error>) -> Void) throws -> Void,
        views:  @escaping (Value) -> BuilderView
    ) -> some View {
        NavigationLink(navigationTitle, destination: EosCompletionView.awaitResult(navigationTitle, call, views: views))
    }

    func awaitResultCode<Value, BuilderView: View>(
        _ call: @escaping (@escaping (Value) -> Void) throws -> Void,
        views:  @escaping (Value) -> BuilderView
    ) -> some View where Value: CallbackInfoWithResult {
        NavigationLink(navigationTitle, destination: EosCompletionView.awaitResultCode(navigationTitle, call, views: views))
    }
}
