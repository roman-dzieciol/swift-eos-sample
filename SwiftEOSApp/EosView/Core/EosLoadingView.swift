
import SwiftUI
import EOSSDK
import SwiftEOS


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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            self.result = result
                        }
                    }
                }
        }
    }
}

protocol CallbackInfoWithResult {
    var ResultCode: EOS_EResult { get }
}

struct EosResultView<CallbackInfo: CallbackInfoWithResult>: View {

    let title: String

    let call: (@escaping (CallbackInfo) -> Void) throws -> Void

    @State
    var result: Result<CallbackInfo, Error>? = nil

    init(_ title: String, _ call: @escaping (@escaping (CallbackInfo) -> Void) throws -> Void) {
        self.title = title
        self.call = call
    }

    func checked(_ call: () throws -> Void) {
        do {
            try call()
        } catch {
            result = .failure(error)
        }
    }

    func load() {
        checked {
            try call() { info in
                checked {
                    guard try info.ResultCode.shouldProceed() else { return }
                    result = .success(info)
                }
            }
        }
    }

    var body: some View {
        Group {
            if case let .success(info) = result {
                KeyValueText("Result:", info.ResultCode.description)
            } else if case let .failure(error) = result {
                KeyValueText("Error:", "\(error)")
            } else {
                ProgressView().onAppear { load() }
            }
        }
        .navigationTitle(title)
    }
}


struct EosCheckedView<Info, BuilderView>: View where BuilderView: View {

    let title: String

    let call: () throws -> Info?
    let views: (Info) -> BuilderView

    @State
    var result: Result<Info, Error>? = nil

    init(
        _ title: String,
        _ call: @escaping () throws -> Info?,
        views:  @escaping (Info) -> BuilderView
    ) {
        self.title = title
        self.call = call
        self.views = views
    }

    func checked(_ call: () throws -> Void) {
        do {
            try call()
        } catch {
            result = .failure(error)
        }
    }

    func load() {
        checked {
            result = .success( try throwingNilResult { try call() } )
        }
    }

    var body: some View {
        Group {
            if case let .success(info) = result {
                views(info)
            } else if case let .failure(error) = result {
                KeyValueText("Error:", "\(error)")
            } else {
                ProgressView().onAppear { load() }
            }
        }
        .navigationTitle(title)
    }
}
