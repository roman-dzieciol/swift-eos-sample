
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosLoadingView<CallbackInfo, BuilderView>: View where BuilderView: View {

    let title: String

    let call: (@escaping (Result<CallbackInfo, Error>) -> Void) throws -> Void
    let views: (CallbackInfo) -> BuilderView

    @State
    var result: Result<CallbackInfo, Error>? = nil

    init(
        _ title: String,
        _ call: @escaping (@escaping (Result<CallbackInfo, Error>) -> Void) throws -> Void,
        views:  @escaping (CallbackInfo) -> BuilderView
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
            try call() { info in
                result = info
            }
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
        .navigationTitle(title)
    }
}

protocol CallbackInfoWithResult {
    var ResultCode: EOS_EResult { get }
}

struct EosResultCodeView<CallbackInfo, BuilderView>: View where CallbackInfo: CallbackInfoWithResult, BuilderView: View {

    let title: String

    let call: (@escaping (CallbackInfo) -> Void) throws -> Void
    let views: (CallbackInfo) -> BuilderView

    @State
    var result: Result<CallbackInfo, Error>? = nil

    init(
        _ title: String,
        _ call: @escaping (@escaping (CallbackInfo) -> Void) throws -> Void,
        views:  @escaping (CallbackInfo) -> BuilderView
    ) {
        self.title = title
        self.call = call
        self.views = views
    }

    init(
        _ title: String,
        _ call: @escaping (@escaping (CallbackInfo) -> Void) throws -> Void
    ) {
        self.title = title
        self.call = call
        self.views = { KeyValueText("Result:", $0.ResultCode.description) as! BuilderView }
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
                views(info)
            } else if case let .failure(error) = result {
                KeyValueText("Error:", "\(error)")
                    .foregroundColor(.red)
            } else {
                ProgressView().onAppear { load() }
            }
        }
        .navigationTitle(title)
    }
}


struct EosCompletionView<Info, BuilderView>: View where BuilderView: View {

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
                    .foregroundColor(.red)
            } else {
                ProgressView().onAppear { load() }
            }
        }
        .navigationTitle(title)
    }
}
