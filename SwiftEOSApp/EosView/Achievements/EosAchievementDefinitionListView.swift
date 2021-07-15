
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosAchievementDefinitionListView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let achievements: [SwiftEOS_Achievements_DefinitionV2]

    var body: some View {
        List(achievements) { achievement in
            NavigationLink(achievement.AchievementId ?? "", destination: EosAchievementDefinitionView(eos: eos, achievement: achievement))
        }
    }
}

extension SwiftEOS_Achievements_DefinitionV2: Identifiable {
    public var id: String { AchievementId ?? UUID().uuidString  }
}

