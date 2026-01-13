import SwiftUI

/// Global app state management
@MainActor
class AppState: ObservableObject {
    @Published var scenes: [Scene] = []
    @Published var currentScene: Scene?
    @Published var isFrozen: Bool = false
    @Published var showTimeline: Bool = false
    @Published var selectedMonth: Int?
    
    init() {
        loadScenes()
    }
    
    func loadScenes() {
        // TODO: Load from SceneStore
        scenes = []
    }
    
    func createNewScene(name: String) -> Scene {
        let scene = Scene(name: name)
        scenes.insert(scene, at: 0)
        currentScene = scene
        return scene
    }
    
    func addFreeze(_ freeze: Freeze, to scene: Scene) {
        if let index = scenes.firstIndex(where: { $0.id == scene.id }) {
            scenes[index].freezes.append(freeze)
            // TODO: Save to SceneStore
        }
    }
    
    func deleteScene(_ scene: Scene) {
        scenes.removeAll { $0.id == scene.id }
        // TODO: Delete from SceneStore
    }
}
