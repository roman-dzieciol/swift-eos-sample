
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


protocol CallbackInfoWithResult {
    var ResultCode: EOS_EResult { get }
}

struct EosCompletionView<Value, BuilderView>: View where BuilderView: View {

    let navigationTitle: String
    let call: (@escaping (Result<Value, Error>) -> Void) throws -> Void
    let views: (Value) -> BuilderView

    @State
    var result: Result<Value, Error>? = nil

    init(
        _ navigationTitle: String,
        _ call: @escaping (@escaping (Result<Value, Error>) -> Void) throws -> Void,
        views:  @escaping (Value) -> BuilderView
    ) {
        self.navigationTitle = navigationTitle
        self.call = call
        self.views = views
    }

    private func load() {
        do {
            try call() { result in
                self.result = result
            }
        } catch {
            result = .failure(error)
        }
    }

    var body: some View {
        Group {
            if case let .success(info) = result {
                views(info)
            } else if case let .failure(error) = result {
                KeyValueText("Error:", "\(error)")
                    .foregroundColor(.red)
            } else {
                ProgressView().onAppear { load() }
            }
        }
        .if(!navigationTitle.isEmpty) {
            $0.navigationTitle(navigationTitle)
        }
    }
}

extension EosCompletionView {

    static func result(
        _ navigationTitle: String,
        _ call: @escaping () throws -> Value,
        views:  @escaping (Value) -> BuilderView
    ) -> Self {
        EosCompletionView(navigationTitle, { completion in
            completion(Result<Value, Error>(catching: { try call() }))
        }, views: views)
    }

    static func awaitResult(
        _ navigationTitle: String,
        _ call: @escaping (@escaping (Result<Value, Error>) -> Void) throws -> Void,
        views:  @escaping (Value) -> BuilderView
    ) -> Self {
        EosCompletionView(navigationTitle, call, views: views)
    }

    static func awaitResultCode(
        _ navigationTitle: String,
        _ call: @escaping (@escaping (Value) -> Void) throws -> Void,
        views:  @escaping (Value) -> BuilderView
    ) -> Self where Value: CallbackInfoWithResult {
        EosCompletionView(navigationTitle, { completion in
            try call() { value in
                do {
                    guard try value.ResultCode.shouldProceed() else { return }
                    completion(.success(value))
                } catch {
                    completion(.failure(error))
                }
            }
        }, views: views)
    }
}
