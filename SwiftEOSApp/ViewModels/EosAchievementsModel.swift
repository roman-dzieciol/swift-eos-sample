
import Foundation
import SwiftEOS
import EOSSDK
import os.log
import Combine


class EosAchievementsModel: ObservableObject {

    let platform: SwiftEOS_Platform_Actor
    weak var events: SwiftEOSEvents?

    var notifyAchievementsUnlockedV2: AnyObject?
    var notifyAchievementsUnlocked: AnyObject?

    init(platform: SwiftEOS_Platform_Actor, events: SwiftEOSEvents) throws {
        self.platform = platform
        self.events = events
        try addNotifyAchievementsUnlockedV2()
        try addNotifyAchievementsUnlocked()
    }

    func addNotifyAchievementsUnlockedV2() throws {
        notifyAchievementsUnlockedV2 = try platform.achievements().AddNotifyAchievementsUnlockedV2(NotificationFn: { info in
            Logger.achievement.log("AchievementsUnlockedV2: \(EosProductUserId(info.UserId).description): \(info.AchievementId ?? "") at: \(info.UnlockTime)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.events?.log("AchievementsUnlockedV2: \(EosProductUserId(info.UserId).description): \(info.AchievementId ?? "") at: \(info.UnlockTime)")
            }
        })
    }

    func addNotifyAchievementsUnlocked() throws {
        notifyAchievementsUnlocked = try platform.achievements().AddNotifyAchievementsUnlocked(NotificationFn: { info in
            Logger.achievement.log("AchievementsUnlocked: \(EosProductUserId(info.UserId).description): \(info.AchievementIds?.joined(separator: ",") ?? "")")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.events?.log("AchievementsUnlocked: \(EosProductUserId(info.UserId).description): \(info.AchievementIds?.joined(separator: ",") ?? "")")
            }
        })
    }
}
