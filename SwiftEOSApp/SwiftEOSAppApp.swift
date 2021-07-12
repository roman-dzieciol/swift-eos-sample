//
//  SwiftEOSAppApp.swift
//  SwiftEOSApp
//
//  Created by Roman Dzieciol on 7/5/21.
//

import SwiftUI


@main
struct SwiftEOSAppApp: App {

    @StateObject var eos = SwiftEOSModel()

    var body: some Scene {
        WindowGroup {
            EosRootView(eos: eos)
        }
    }
}
