
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosLoginView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    @State
    var isLoggingIn: Bool = false

    var body: some View {

        List {
            if isLoggingIn {
                ProgressView()
            } else {
                Button("Login") {
                    isLoggingIn = true
                    asserting { try eos.login({ result in
                        DispatchQueue.main.async {
                            isLoggingIn = false
                        }
                    })}
                }
            }
        }
    }
}
