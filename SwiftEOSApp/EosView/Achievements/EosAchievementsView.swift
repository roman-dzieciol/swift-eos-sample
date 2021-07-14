

import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK

struct EosAchievementsView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    var body: some View {

        List {
            NavigationLink("Query Definitions", destination: EosResultView("Query Definitions") {
                try eos.achievements.QueryDefinitions(LocalUserId: eos.connectModel.localUserId!, EpicUserId_DEPRECATED: nil, HiddenAchievementIds_DEPRECATED: nil, CompletionDelegate: $0)
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            })

            NavigationLink("Get Definitions", destination: EosCheckedView("Get Definitions") {
                let num = try eos.achievements.GetAchievementDefinitionCount()
                return try (0..<num).map { idx in try throwingNilResult { try eos.achievements.CopyAchievementDefinitionV2ByIndex(AchievementIndex: idx) } }
            } views: {
                EosAchievementDefinitionListView(eos: eos, achievements: $0)
            })
        }
    }
}
