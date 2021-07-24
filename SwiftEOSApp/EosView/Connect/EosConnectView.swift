
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

            NavigationLink("Get Logged In Users", destination: EosCheckedView("Get Logged In Users") {
                let accountsNum = try eos.connect.GetLoggedInUsersCount()
                return try (0..<accountsNum).compactMap { try eos.connect.GetLoggedInUserByIndex(Index: $0) }
            } views: {
                EosProductUserIdListView(eos: eos, productUserIds: $0)
            })

            NavigationLink("Copy Product User Info", destination: EosCheckedView("Copy Product User Info") {
                try eos.connect.CopyProductUserInfo(TargetUserId: eos.connectModel.localUserId)
            } views: {
                EosProductUserInfoView(eos: eos, info: $0)
            })
        }
    }
}

extension SwiftEOS_Connect_DeleteDeviceIdCallbackInfo: CallbackInfoWithResult {}

