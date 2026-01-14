import Combine
import SwiftUI

/// Global app state management
@MainActor
class AppState: ObservableObject {
  @Published var scenes: [CaptureScene] = []
  @Published var currentScene: CaptureScene?
  @Published var isFrozen: Bool = false
  @Published var showTimeline: Bool = false {
    didSet {
      if showTimeline {
        // Spec: scene persists until user enters timeline
        currentScene = nil
      }
    }
  }
  @Published var selectedMonth: Int?

  init() {
    loadScenes()
  }

  func loadScenes() {
    // TODO: Load from SceneStore
    scenes = []
  }

  func createNewScene(name: String) -> CaptureScene {
    let scene = CaptureScene(name: name)
    scenes.insert(scene, at: 0)
    currentScene = scene
    return scene
  }

  func addFreeze(_ freeze: Freeze, to scene: CaptureScene) {
    if let index = scenes.firstIndex(where: { $0.id == scene.id }) {
      scenes[index].freezes.append(freeze)
      currentScene = scenes[index]  // Keep currentScene in sync
      // TODO: Save to SceneStore
    }
  }

  func deleteScene(_ scene: CaptureScene) {
    scenes.removeAll { $0.id == scene.id }
    // TODO: Delete from SceneStore
  }
}
