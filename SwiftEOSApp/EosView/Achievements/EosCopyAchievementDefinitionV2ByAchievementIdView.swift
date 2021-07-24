
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosCopyAchievementDefinitionV2ByAchievementIdView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    @SceneStorage(EosSceneState.EosCopyAchievementDefinitionV2ByAchievementIdView)
    var achievementId: String = ""

    init(
        eos: SwiftEOSModel,
        achievementId: String? = nil
    ) {
        self.eos = eos
        if let achievementId = achievementId {
            self.achievementId = achievementId
        }
    }

    var body: some View {
        List {
            KeyValueTextField("Achievement Id:", $achievementId)
            EosNavigationLink("Copy AchievementDefinitionV2 By Achievement Id").result {
                return try eos.achievements.CopyAchievementDefinitionV2ByAchievementId(AchievementId: achievementId)
            } views: {
                EosAchievementDefinitionView(eos: eos, achievement: $0)
            }
        }
    }
}

