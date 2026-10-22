import SwiftUI
import SwiftData
import AppIntents

@main
struct ContextExtendApp: App {
    init() {
        ContextExtendShortcuts.updateAppShortcutParameters()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DataStore.container)
    }
}
