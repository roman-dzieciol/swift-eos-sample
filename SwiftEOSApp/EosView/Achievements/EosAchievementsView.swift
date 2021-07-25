
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosAchievementsView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    var body: some View {

        List {
            EosNavigationLink("Query Definitions").awaitResultCode {
                try eos.achievements.QueryDefinitions(LocalUserId: eos.connectModel.localUserId, EpicUserId_DEPRECATED: nil, HiddenAchievementIds_DEPRECATED: nil, CompletionDelegate: $0)
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            }

            EosNavigationLink("Get Definitions By Index").result {
                let num = try eos.achievements.GetAchievementDefinitionCount()
                return try (0..<num).map { idx in try throwingNilResult { try eos.achievements.CopyAchievementDefinitionV2ByIndex(AchievementIndex: idx) } }
            } views: { (items: [SwiftEOS_Achievements_DefinitionV2]) in
                EosListView(eos: eos, items: items) { eos, item in
                    EosAchievementDefinitionView(eos: eos, achievement: item)
                }
            }

            EosNavigationLink("Get Definitions By Id").view {
                EosCopyAchievementDefinitionV2ByAchievementIdView(eos: eos)
            }

            EosNavigationLink("Query Player Achievements").view {
                EosQueryPlayerAchievementsView(eos: eos, localUserId: eos.connectModel.localUserId, targetUserId: eos.connectModel.localUserId)
            }

            EosNavigationLink("Copy Player Achievement By Index").result {
                let num = try eos.achievements.GetPlayerAchievementCount(UserId: eos.connectModel.localUserId)
                return try (0..<num).map { idx in try throwingNilResult {
                    try eos.achievements.CopyPlayerAchievementByIndex(TargetUserId: eos.connectModel.localUserId,
                                                                      AchievementIndex: idx,
                                                                      LocalUserId: eos.connectModel.localUserId) } }
            } views: { (items: [SwiftEOS_Achievements_PlayerAchievement]) in
                EosListView(eos: eos, items: items) { eos, item in
                    EosPlayerAchievementView(eos: eos, achievement: item)
                }
            }
            
            EosNavigationLink("Copy Player Achievement By Id").view {
                EosCopyPlayerAchievementByAchievementIdView(
                    eos: eos,
                    targetUserId: eos.connectModel.localUserId,
                    localUserId: eos.connectModel.localUserId)
            }
        }
    }
}

extension SwiftEOS_Achievements_UnlockedAchievement: Identifiable {
    public var id: String { AchievementId ?? UUID().uuidString  }
}

extension SwiftEOS_Achievements_DefinitionV2: Identifiable {
    public var id: String { AchievementId ?? UUID().uuidString  }
}

extension SwiftEOS_Achievements_PlayerAchievement: Identifiable {
    public var id: String { AchievementId ?? UUID().uuidString  }
}


