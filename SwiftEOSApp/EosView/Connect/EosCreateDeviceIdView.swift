
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosCreateDeviceIdView: View {

    let title = "Create Device Id"

    @ObservedObject
    var eos: SwiftEOSModel

    @State
    var name: String

    var body: some View {
        List {
            KeyValueTextField("Device:", $name)
            NavigationLink(title, destination: EosResultCodeView(title) { completion in
                try eos.connect.CreateDeviceId(DeviceModel: name) { completion($0) }
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            })
        }
        .navigationTitle(title)
    }
}

extension SwiftEOS_Connect_CreateDeviceIdCallbackInfo: CallbackInfoWithResult {}
