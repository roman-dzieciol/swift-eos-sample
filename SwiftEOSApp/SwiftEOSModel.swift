
import Foundation
import SwiftEOS
import EOSSDK
import os.log
import Combine
import AuthenticationServices


extension SwiftEOS_Platform_Actor {

    public func auth() throws -> SwiftEOS_Auth_Actor {
        try throwingNilResult(GetAuthInterface)
    }

    public func userInfo() throws -> SwiftEOS_UserInfo_Actor {
        try throwingNilResult(GetUserInfoInterface)
    }
}


class SwiftEOSModel: ObservableObject {

    @Published var isLoggedIn: Bool = false
    @Published var localUserId: EOS_EpicAccountId?

    var auth: SwiftEOS_Auth_Actor {
        asserting(platform.auth)
    }

    var userInfo: SwiftEOS_UserInfo_Actor {
        asserting(platform.userInfo)
    }

    let queue = DispatchQueue(label: "eos")

    var platform: SwiftEOS_Platform_Actor!
    var authNotify: AnyObject?

    init() {
        Logger.app.log("init SwiftEOSModel")
        asserting(initialize)
    }

    deinit {
        Logger.app.log("deinit SwiftEOSModel")
        EOS_Platform_Release(platform.Handle)
        asserting(SwiftEOS_Shutdown)
    }

    func initialize() throws {

        try SwiftEOS_Initialize(Options: .init(AllocateMemoryFunction: nil,
                                               ReallocateMemoryFunction: nil,
                                               ReleaseMemoryFunction: nil,
                                               ProductName: "SwiftEOS",
                                               ProductVersion: "1.0",
                                               Reserved: nil,
                                               SystemInitializeOptions: nil,
                                               OverrideThreadAffinity: nil))

        try SwiftEOS_Logging_SetLogLevel(LogCategory: .EOS_LC_ALL_CATEGORIES, LogLevel: .EOS_LOG_VeryVerbose)

        try SwiftEOS_Logging_SetCallback { ptr in
            Logger.log(ptr)
        }

        let platformHandle = try SwiftEOS_Platform_Create(Options: SwiftEOS_Platform_Options(
            Reserved: nil,
            ProductId: "b1d7c98288894e3c974a3c5cea4d8d96",
            SandboxId: "6d3208980404483a8e104183c84f248e",
            ClientCredentials: SwiftEOS_Platform_ClientCredentials(
                ClientId: "xyza7891kqydbLUAGkkvGGj07XOdcQIR",
                ClientSecret: "Z2OslQ04RsWmzBibGyY/T7GHQX/52UMetIgS7z6z/aA"),
            bIsServer: false,
            EncryptionKey: nil,
            OverrideCountryCode: nil,
            OverrideLocaleCode: nil,
            DeploymentId: "214e791b208b4315a3a1e2b029d5569f",
            Flags: 0,
            CacheDirectory: nil,
            TickBudgetInMilliseconds: 100,
            RTCOptions: nil))

        platform = SwiftEOS_Platform_Actor(Handle: platformHandle)

        authNotify = try platform.auth().AddNotifyLoginStatusChanged(Notification: { info in
            os_log("%{public}s", " \(String(describing: info.LocalUserId)): \(info.PrevStatus) -> \(info.CurrentStatus)")
            DispatchQueue.main.async { [weak self] in
                self?.isLoggedIn = info.CurrentStatus == .EOS_LS_LoggedIn
            }
        })

        tick()
    }

    func tick() {
        queue.asyncAfter(deadline: .now() + 0.1) {
            DispatchQueue.main.async {
                self.platform.Tick()
                self.tick()
            }
        }
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
                os_log("login: %{public}s", SwiftEOS_EResult_ToString(Result: info.ResultCode) ?? "")

                guard asserting(info.ResultCode.isComplete) else { return }

                if info.ResultCode == .EOS_Success {
                    os_log("login: %{public}s", " \(String(describing: info.LocalUserId)): \(String(describing: info.PinGrantInfo)) \(String(describing: info.ContinuanceToken)) \(String(describing: info.AccountFeatureRestrictedInfo))")

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
