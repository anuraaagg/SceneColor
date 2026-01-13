import SwiftUI

@main
struct SceneColorApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            LiveScanView()
                .environmentObject(appState)
        }
    }
}
