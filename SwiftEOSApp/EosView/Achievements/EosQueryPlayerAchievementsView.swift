
import Foundation
import SwiftUI
import SwiftEOS
import EOSSDK


struct EosQueryPlayerAchievementsView: View {

    @ObservedObject
    var eos: SwiftEOSModel

    let localUserId: EOS_ProductUserId?

    let targetUserId: EOS_ProductUserId?

    var body: some View {
        List {
            KeyValueText("Local:", EosProductUserId(localUserId))
            KeyValueText("Target:", EosProductUserId(targetUserId))
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
