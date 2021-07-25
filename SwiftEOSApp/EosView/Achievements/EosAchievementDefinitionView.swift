
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosAchievementDefinitionView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let achievement: SwiftEOS_Achievements_DefinitionV2

    var body: some View {
        List {
            Group {
                KeyValueText("AchievementId:", achievement.AchievementId)
                KeyValueText("UnlockedDisplayName:", achievement.UnlockedDisplayName)
                KeyValueText("UnlockedDescription:", achievement.UnlockedDescription)
                KeyValueText("LockedDisplayName:", achievement.LockedDisplayName)
                KeyValueText("LockedDescription:", achievement.LockedDescription)
                KeyValueText("FlavorText:", achievement.FlavorText)
            }
            Group {
                KeyValueText("UnlockedIconURL:", achievement.UnlockedIconURL)
                NavigationLink("Unlocked Icon", destination: EosImage(achievement.UnlockedIconURL))
                KeyValueText("LockedIconURL:", achievement.LockedIconURL)
                NavigationLink("Locked Icon", destination: EosImage(achievement.LockedIconURL))
            }
            KeyValueText("bIsHidden:", "\(achievement.bIsHidden ? "true" : "false")")

            if let statThresholds = achievement.StatThresholds {
                ForEach(0..<statThresholds.count) { index in
                    KeyValueText(statThresholds[index].Name ?? "", "\(statThresholds[index].Threshold)")
                }
            }
        }
    }
}



