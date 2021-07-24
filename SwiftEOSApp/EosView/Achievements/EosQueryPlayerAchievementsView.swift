
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
            KeyValueText("Local:", EosEpicAccountId(localUserId))
            KeyValueText("Target:", EosEpicAccountId(targetUserId))
            EosNavigationLink("Query Player Achievements").awaitResultCode {
                try eos.achievements.QueryPlayerAchievements(TargetUserId: targetUserId, LocalUserId: localUserId, CompletionDelegate: $0)
            } views: {
                KeyValueText("Result:", $0.ResultCode.description)
            }
        }
        .navigationTitle("Query Player Achievements")
    }
}

extension SwiftEOS_Achievements_OnQueryPlayerAchievementsCompleteCallbackInfo: CallbackInfoWithResult {}
