
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosRootView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    @State
    var isDisplayingLog: Bool = false

    @State
    var isLoggingIn: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            NavigationView {
                EosMainView(eos: eos)
                    .navigationTitle("Epic Online Services")
            }


            loginView
            logView

            Divider()
            Group {
                KeyValueText("Epic - \(eos.authModel.currentStatus.description)", EosEpicAccountId(eos.authModel.localUserId))
                KeyValueText("Product - \(eos.connectModel.currentStatus.description)", EosProductUserId(eos.connectModel.localUserId))
            }.padding([.horizontal])
        }
    }

    @ViewBuilder
    var loginView: some View {
        if !eos.authModel.isLoggedIn {
            Divider()
            Group {
                if !isLoggingIn {
                    Button("Login All") {
                        self.isLoggingIn = true
                        try? eos.authModel.login { _ in
                            try? eos.connectModel.loginDevice { _ in
                                self.isLoggingIn = false
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
        }
    }

    @ViewBuilder
    var logView: some View {

        if let logItem = eos.events.log.last {
            Divider()
            if isDisplayingLog {
                HStack {
                    List(eos.events.log) { item in
                        Text(item.string)
                            .font(.system(.footnote, design: .monospaced))
                            .foregroundColor(.eosAccent)
                    }
                    Color.eosAccent
                        .frame(width: 1)
                }
                .onTapGesture { isDisplayingLog.toggle() }
            } else {
                HStack {
                    Text(logItem.string)
                        .font(.system(.footnote, design: .monospaced))
                    Spacer()
                    Image(systemName: "chevron.up")
                }
                .padding()
                .foregroundColor(.eosAccent)
                .onTapGesture { isDisplayingLog.toggle() }
            }
        }
    }
}
