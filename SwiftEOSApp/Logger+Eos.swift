
import Foundation
import os.log


extension Logger {
    public static let app = Logger(subsystem: "dev.roman.eon.app", category: "App")
    public static let auth = Logger(subsystem: "dev.roman.eon.app", category: "Auth")
    public static let connect = Logger(subsystem: "dev.roman.eon.app", category: "Connect")
    public static let achievement = Logger(subsystem: "dev.roman.eon.app", category: "Achievement")

}
