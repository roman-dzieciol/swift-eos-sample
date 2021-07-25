
import Foundation
import SwiftEOS
import EOSSDK
import os.log
import Combine
import AuthenticationServices


extension OpaquePointer: Identifiable {
    public var id: Int { Int(bitPattern: UnsafeRawPointer(self)) }
}

extension SwiftEOS_Platform_Actor {

    func auth() throws -> SwiftEOS_Auth_Actor {
        try throwingNilResult { GetAuthInterface() }
    }

    func userInfo() throws -> SwiftEOS_UserInfo_Actor {
        try throwingNilResult { GetUserInfoInterface() }
    }

    func achievements() throws -> SwiftEOS_Achievements_Actor {
        try throwingNilResult { GetAchievementsInterface() }
    }

    func connect() throws -> SwiftEOS_Connect_Actor {
        try throwingNilResult { GetConnectInterface() }
    }
}


extension SwiftEOSModel {

    var auth: SwiftEOS_Auth_Actor {
        asserting(platform.auth)
    }

    var userInfo: SwiftEOS_UserInfo_Actor {
        asserting(platform.userInfo)
    }

    var achievements: SwiftEOS_Achievements_Actor {
        asserting(platform.achievements)
    }

    var connect: SwiftEOS_Connect_Actor {
        asserting(platform.connect)
    }
}

class SwiftEOSModel: ObservableObject {

    let queue = DispatchQueue(label: "eos")

    var platform: SwiftEOS_Platform_Actor!

    var authModel: EosAuthModel!
    var connectModel: EosConnectModel!
    var achievementsModel: EosAchievementsModel!

    var subscriptions = Set<AnyCancellable>()

    @Published
    var events: SwiftEOSEvents


    init() {
        Logger.app.log("init SwiftEOSModel")
        self.events = SwiftEOSEvents()
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

        authModel = try EosAuthModel(platform: platform, events: events)
        authModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &subscriptions)

        connectModel = try EosConnectModel(platform: platform, events: events)
        connectModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &subscriptions)

        achievementsModel = try EosAchievementsModel(platform: platform, events: events)
        achievementsModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &subscriptions)

        events.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &subscriptions)

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

}
