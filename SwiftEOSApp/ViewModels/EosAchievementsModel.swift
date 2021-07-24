
import Foundation
import SwiftEOS
import EOSSDK
import os.log
import Combine


class EosAchievementsModel: ObservableObject {

    let platform: SwiftEOS_Platform_Actor

    var notifyAchievementsUnlockedV2: AnyObject?

    init(platform: SwiftEOS_Platform_Actor) throws {
        self.platform = platform
        try addNotifyAchievementsUnlockedV2()
    }

    func addNotifyAchievementsUnlockedV2() throws {
        notifyAchievementsUnlockedV2 = try platform.achievements().AddNotifyAchievementsUnlockedV2(NotificationFn: { info in

            Logger.achievement.log("\(EosProductUserId(info.UserId).description): \(info.AchievementId ?? "") at: \(info.UnlockTime)")
            DispatchQueue.main.async { [weak self] in

            }
        })
    }
}
