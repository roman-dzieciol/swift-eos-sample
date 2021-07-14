
import Foundation
import SwiftEOS
import EOSSDK
import os.log
import Combine
import AuthenticationServices

class EosAuthModel: ObservableObject {

    @Published var isLoggedIn: Bool = false
    @Published var currentStatus: EOS_ELoginStatus = .EOS_LS_NotLoggedIn
    @Published var localUserId: EOS_EpicAccountId?

    let platform: SwiftEOS_Platform_Actor

    var authNotify: AnyObject?

    init(platform: SwiftEOS_Platform_Actor) throws {
        self.platform = platform
        try addLoginotification()
    }

    func toString(id: EOS_EpicAccountId?) -> String? {
        do {
            guard let id = id else { return nil }
            return try throwingNilResult { try SwiftEOS_EpicAccountId_ToString(AccountId: id) }
        } catch {
            return "<Error: \(error)>"
        }
    }

    func addLoginotification() throws {

        authNotify = try platform.auth().AddNotifyLoginStatusChanged(Notification: { info in
            Logger.auth.log("\(String(describing: info.LocalUserId), privacy: .public): \(info.PrevStatus) -> \(info.CurrentStatus)")
            DispatchQueue.main.async { [weak self] in
                self?.currentStatus = info.CurrentStatus
                self?.isLoggedIn = info.CurrentStatus == .EOS_LS_LoggedIn
                if self?.isLoggedIn != true {
                    self?.localUserId = nil
                }
            }
        })
    }

    func login(_ completion: @escaping (Result<Void,Error>) -> Void) throws {

        try loginPersistent { result in
            do {
                switch result {
                case .success:
                    return completion(.success(()))

                case .failure:
                    return try self.loginThroughPortal(completion)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func loginPersistent(_ completion: @escaping (Result<Void,Error>) -> Void) throws {

        let credentials = SwiftEOS_Auth_Credentials(
            Id: nil,
            Token: nil,
            Type: .EOS_LCT_PersistentAuth,
            SystemAuthCredentialsOptions: nil,
            ExternalType: .EOS_ECT_EPIC
        )

        try Login(Credentials: credentials, ScopeFlags: .EOS_AS_NoFlags, CompletionDelegate: { info in
            do {
                if info.ResultCode == .EOS_Success {
                    return completion(.success(()))
                }

                // Check the specific error if we fail to complete a persistent login attempt, as we may need to flush any stored secure credentials
                switch info.ResultCode {
                case EOS_EResult.EOS_Canceled,
                    EOS_EResult.EOS_AlreadyPending,
                    EOS_EResult.EOS_TooManyRequests,
                    EOS_EResult.EOS_TimedOut,
                    EOS_EResult.EOS_ServiceFailure,
                    EOS_EResult.EOS_NotFound:
                    Logger.app.log("Persistent auth fail \(info.ResultCode)")
                    return completion(.failure(SwiftEOSError.result(info.ResultCode)))

                default:
                    Logger.app.log("Deleting persistent auth")

                    try self.platform.auth().DeletePersistentAuth(RefreshToken: nil) { info in
                        guard asserting(info.ResultCode.isComplete) else { return }
                        return completion(.failure(SwiftEOSError.result(info.ResultCode)))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        })
    }

    func loginThroughPortal(_ completion: @escaping (Result<Void,Error>) -> Void) throws {
        let webAuthObj = EOSWebAuthenticationPresentationContextProviding()

        try withPointerManager { pointerManager in

            let sdkAuthOptions = EOS_IOS_Auth_CredentialsOptions(
                ApiVersion: EOS_IOS_AUTH_CREDENTIALSOPTIONS_API_LATEST,
                PresentationContextProviding: Unmanaged.passRetained(webAuthObj).retain().toOpaque()
            )
            let authOptionsPtr = pointerManager.managedMutablePointer(copyingValueOrNilPointer: sdkAuthOptions)

            let credentials = SwiftEOS_Auth_Credentials(
                Id: nil,
                Token: nil,
                Type: .EOS_LCT_AccountPortal,
                SystemAuthCredentialsOptions: authOptionsPtr,
                ExternalType: .EOS_ECT_EPIC
            )

            try Login(Credentials: credentials, ScopeFlags: .EOS_AS_NoFlags, CompletionDelegate: { info in
                if info.ResultCode == .EOS_Success {
                    completion(.success(()))
                } else {
                    completion(.failure(SwiftEOSError.result(info.ResultCode)))
                }
            })
        }
    }

    private func Login(
        Credentials: SwiftEOS_Auth_Credentials?,
        ScopeFlags: EOS_EAuthScopeFlags,
        CompletionDelegate: @escaping (SwiftEOS_Auth_LoginCallbackInfo) -> Void
    ) throws {
        try platform.auth().Login(Credentials: Credentials, ScopeFlags: ScopeFlags, CompletionDelegate: { info in
            DispatchQueue.main.async {
                Logger.auth.log("\(info.ResultCode.description, privacy: .public)")

                guard asserting(info.ResultCode.isComplete) else { return }

                if info.ResultCode == .EOS_Success {
                    Logger.auth.log("""
                                    \(self.toString(id: info.LocalUserId) ?? "", privacy: .public): \
                                    \(String(describing: info.PinGrantInfo)) \
                                    \(String(describing: info.ContinuanceToken)) \
                                    \(String(describing: info.AccountFeatureRestrictedInfo))
                                    """)

                    self.localUserId = info.LocalUserId
                }

                CompletionDelegate(info)
            }
        })
    }
}

class EOSWebAuthenticationPresentationContextProviding: UIViewController, ASWebAuthenticationPresentationContextProviding {

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}


