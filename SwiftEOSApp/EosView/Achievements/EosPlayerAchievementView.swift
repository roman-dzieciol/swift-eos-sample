
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosPlayerAchievementView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let achievement: SwiftEOS_Achievements_PlayerAchievement

    var body: some View {
        List {

            KeyValueText("AchievementId:", achievement.AchievementId)
            KeyValueText("Progress:", "\(achievement.Progress)")
            KeyValueText("UnlockTime:", "\(achievement.UnlockTime)")

            if let items = achievement.StatInfo {
                ForEach(0..<items.count) { index in
                    KeyValueText(items[index].Name ?? "", "\(items[index].CurrentValue)/\(items[index].ThresholdValue)")
                }
            }

            KeyValueText("DisplayName:", achievement.DisplayName)
            KeyValueText("Description:", achievement.Description)
            KeyValueText("IconURL:", achievement.IconURL)
            EosNavigationLink("Icon").view {
                EosImage(achievement.IconURL)
            }
            KeyValueText("FlavorText:", achievement.FlavorText)

            EosNavigationLink("Unlock").awaitResultCode { completion in
                try eos.achievements.UnlockAchievements(
                    UserId: eos.connectModel.localUserId,
                    AchievementIds: [achievement.id],
                    CompletionDelegate: completion)
            } views: { info in
                Text("AchievementsCount: \(info.AchievementsCount)")
            }
        }
    }
}

extension SwiftEOS_Achievements_OnUnlockAchievementsCompleteCallbackInfo: CallbackInfoWithResult {}


