
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosConnectView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let connectModel: EosConnectModel

    var body: some View {

        List {

            NavigationLink("Login (Device)", destination: EosLoadingView("Login (Device)") { completion in
                try eos.connectModel.loginDevice { completion($0) }
            } views: {
                Text("Logged in")
            })

            NavigationLink("Create Device Id", destination: EosCreateDeviceIdView(eos: eos, name: UIDevice.current.name))

            NavigationLink("Delete Device Id", destination: EosResultView("Delete Device Id") { completion in
                try eos.connect.DeleteDeviceId() { completion($0) }
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            })
        }
    }
}

extension SwiftEOS_Connect_DeleteDeviceIdCallbackInfo: CallbackInfoWithResult {}

