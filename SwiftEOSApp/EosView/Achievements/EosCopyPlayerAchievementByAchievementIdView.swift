
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosCopyPlayerAchievementByAchievementIdView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    @State
    var achievementId: String

    @State
    var targetUserIdString: String

    @State
    var localUserIdString: String

    init(
        eos: SwiftEOSModel,
        targetUserId: EOS_ProductUserId?,
        localUserId: EOS_ProductUserId?
    ) {
        self.eos = eos
        self.achievementId = ""
        self.targetUserIdString = (try? SwiftEOS_ProductUserId_ToString(AccountId: targetUserId)) ?? ""
        self.localUserIdString = (try? SwiftEOS_ProductUserId_ToString(AccountId: localUserId)) ?? ""
    }

    var body: some View {
        List {
            KeyValueTextField("Achievement Id:", $achievementId)
            KeyValueTextField("TargetUserId:", $targetUserIdString)
            KeyValueTextField("LocalUserId:", $localUserIdString)
            EosNavigationLink("Copy Player Achievement By Achievement Id").result { () -> SwiftEOS_Achievements_PlayerAchievement in
                let targetUserId = SwiftEOS_ProductUserId_FromString(ProductUserIdString: targetUserIdString)
                let localUserId = SwiftEOS_ProductUserId_FromString(ProductUserIdString: localUserIdString)
                return try eos.achievements.CopyPlayerAchievementByAchievementId(TargetUserId: targetUserId, AchievementId: achievementId, LocalUserId: localUserId)
            } views: {
                KeyValueText("Result:", "\($0)")
            }
        }
    }
}


