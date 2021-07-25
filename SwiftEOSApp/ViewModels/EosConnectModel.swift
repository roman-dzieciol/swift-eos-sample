
import Foundation
import SwiftEOS
import EOSSDK
import os.log
import Combine
import AuthenticationServices


class EosConnectModel: ObservableObject {

    @Published var isLoggedIn: Bool = false
    @Published var currentStatus: EOS_ELoginStatus = .EOS_LS_NotLoggedIn
    @Published var localUserId: EOS_ProductUserId?


    let platform: SwiftEOS_Platform_Actor
    weak var events: SwiftEOSEvents?

    var connectNotify: AnyObject?

    init(platform: SwiftEOS_Platform_Actor, events: SwiftEOSEvents) throws {
        self.platform = platform
        self.events = events
        try addLoginotification()
    }

    func addLoginotification() throws {

        connectNotify = try platform.connect().AddNotifyLoginStatusChanged(Notification: { info in
            Logger.connect.log("\(String(describing: info.LocalUserId), privacy: .public): \(info.PreviousStatus) -> \(info.CurrentStatus)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.events?.log("ProductId: \(EosProductUserId(info.LocalUserId).description): \(info.PreviousStatus) -> \(info.CurrentStatus)")
                self.currentStatus = info.CurrentStatus
                self.isLoggedIn = info.CurrentStatus == .EOS_LS_LoggedIn
                if self.isLoggedIn != true {
                    self.localUserId = nil
                }
            }
        })
    }

    func loginDevice(_ completion: @escaping (Result<Void,Error>) -> Void) throws {

        let credentials = SwiftEOS_Connect_Credentials(
            Token: nil,
            Type: EOS_EExternalCredentialType.EOS_ECT_DEVICEID_ACCESS_TOKEN
        )

        let loginInfo = SwiftEOS_Connect_UserLoginInfo(DisplayName: UIDevice.current.name)

        try platform.connect().Login(
            Credentials: credentials,
            UserLoginInfo: loginInfo,
            CompletionDelegate: { info in
            do {
                guard try info.ResultCode.shouldProceed() else { return }
                self.localUserId = info.LocalUserId
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        })
    }
}
