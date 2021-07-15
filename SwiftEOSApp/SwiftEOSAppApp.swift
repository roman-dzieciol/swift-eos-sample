
import SwiftUI
import ObjectiveC
import AudioToolbox


@main
struct SwiftEOSAppApp: App {

    @StateObject var eos = SwiftEOSModel()

    init() {
        // SwiftUI background color support is somewhere between broken and not implemented, so sudo it for the sample app
        UIColor.swizzle_systemBackground()
        UIColor.swizzle_tableBackgroundColor()
        UIColor.swizzle_tableCellPlainBackgroundColor()
    }

    func playSound(note: String) {
        let filePath = Bundle.main.path(forResource: note, ofType: "wav")!
        let soundURL = NSURL(fileURLWithPath: filePath)
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }

    var body: some Scene {
        WindowGroup {
            EosRootView(eos: eos)
                .accentColor(.eosAccent)
                .environment(\.colorScheme, .dark)
                .foregroundColor(.eosPrimary)
                .onAppear {
                    playSound(note: "launch")
                }
        }
    }
}


extension Color {
    static var translatorBackground: Color {
        Color(red: Double(0x10) / 255.0, green: Double(0x1c) / 255.0, blue: Double(0x10) / 255.0)
    }

    static var eosBackground: Color {
        translatorBackground
    }

    static var eosBackgroundView: some View {
        translatorBackground.edgesIgnoringSafeArea(.all)
    }

    static var eosAccent: Color {
        Color(hue: 200.0/360.0, saturation: 1.0, brightness: 1.0)
    }

    static var eosPrimary: Color {
        Color(hue: 120.0/360.0, saturation: 1.0, brightness: 1.0)
    }

    static var eosSecondary: Color {
        Color(hue: 120.0/360.0, saturation: 0.0, brightness: 0.7)
    }
}

extension UIColor {

    static func swizzle_systemBackground() {
        let swizzledMethod = class_getClassMethod(UIColor.self, #selector(getter: swizzled_systemBackground))!
        let originalMethod = class_getClassMethod(UIColor.self, #selector(getter: systemBackground))!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    static func swizzle_tableBackgroundColor() {
        let swizzledMethod = class_getClassMethod(UIColor.self, #selector(getter: swizzled_tableBackgroundColor))!
        let originalMethod = class_getClassMethod(UIColor.self, NSSelectorFromString("tableBackgroundColor"))!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    static func swizzle_tableCellPlainBackgroundColor() {
        let swizzledMethod = class_getClassMethod(UIColor.self, #selector(getter: swizzled_tableCellPlainBackgroundColor))!
        let originalMethod = class_getClassMethod(UIColor.self, NSSelectorFromString("tableCellPlainBackgroundColor"))!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    @objc class var swizzled_systemBackground: UIColor {
        UIColor(Color.translatorBackground)
    }

    @objc class var swizzled_tableBackgroundColor: UIColor {
        UIColor(Color.translatorBackground)
    }

    @objc class var swizzled_tableCellPlainBackgroundColor: UIColor {
        UIColor(Color.translatorBackground)
    }
}
