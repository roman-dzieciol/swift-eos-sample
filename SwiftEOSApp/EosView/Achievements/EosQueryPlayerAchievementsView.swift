
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosQueryPlayerAchievementsView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let localUserId: EOS_EpicAccountId

    let targetUserId: EOS_EpicAccountId

    var body: some View {
        List {
            KeyValueText("Local:", eos.authModel.toString(id: localUserId))
            KeyValueText("Target:", eos.authModel.toString(id: targetUserId))
            NavigationLink("Query Player Achievements", destination: EosCompletionResultCodeView("Query Player Achievements") {
                try eos.achievements.QueryPlayerAchievements(TargetUserId: targetUserId, LocalUserId: localUserId, CompletionDelegate: $0)
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            })
        }
        .navigationTitle("Query Player Achievements")
    }
}

extension SwiftEOS_Achievements_OnQueryPlayerAchievementsCompleteCallbackInfo: CallbackInfoWithResult {}
