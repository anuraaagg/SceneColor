import SwiftUI

/// Timeline view showing all saved scenes
struct TimelineView: View {
  @EnvironmentObject var appState: AppState
  @Environment(\.dismiss) var dismiss

  @State private var editingSceneID: UUID?
  @State private var newName: String = ""
  @State private var selectedFreeze: Freeze?

  var body: some View {
    NavigationStack {
      ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()

        if appState.scenes.isEmpty {
          ContentUnavailableView(
            "No Scenes Yet",
            systemImage: "photo.on.rectangle.angled",
            description: Text("Freeze your first color moment to get started")
          )
        } else {
          List {
            ForEach(appState.scenes) { scene in
              VStack(alignment: .leading, spacing: 12) {
                if editingSceneID == scene.id {
                  TextField(
                    "Scene Name", text: $newName,
                    onCommit: {
                      saveName(for: scene)
                    }
                  )
                  .textFieldStyle(.roundedBorder)
                  .onSubmit { saveName(for: scene) }
                } else {
                  Text(scene.name)
                    .font(.headline)
                    .onTapGesture(count: 2) {
                      editingSceneID = scene.id
                      newName = scene.name
                    }
                }

                HStack(spacing: 8) {
                  ForEach(scene.freezes) { freeze in
                    Circle()
                      .fill(Color.primary.opacity(0.8))
                      .frame(width: 8, height: 8)
                      .onTapGesture {
                        withAnimation {
                          selectedFreeze = freeze
                        }
                      }
                  }
                }
              }
              .padding(.vertical, 8)
              .listRowBackground(Color.clear)
              .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteScenes)
          }
          .listStyle(.plain)
        }

        if let freeze = selectedFreeze {
          DetailOverlay(freeze: freeze) {
            withAnimation {
              selectedFreeze = nil
            }
          }
          .transition(.opacity.combined(with: .scale))
        }
      }
      .navigationTitle("Timeline")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") { dismiss() }
        }
      }
    }
  }

  private func saveName(for scene: CaptureScene) {
    if let index = appState.scenes.firstIndex(where: { $0.id == scene.id }) {
      appState.scenes[index].name = newName
    }
    editingSceneID = nil
  }

  private func deleteScenes(at offsets: IndexSet) {
    for index in offsets {
      appState.deleteScene(appState.scenes[index])
    }
  }
}

#Preview {
  TimelineView()
    .environmentObject(AppState())
}
