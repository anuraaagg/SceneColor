import SwiftUI

/// Timeline view showing all saved scenes
struct TimelineView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selectedMonth: Int? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Month filter bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(1...12, id: \.self) { month in
                            MonthPill(month: month, isSelected: selectedMonth == month) {
                                selectedMonth = selectedMonth == month ? nil : month
                            }
                        }
                    }
                    .padding()
                }
                
                // Scene list
                if appState.scenes.isEmpty {
                    ContentUnavailableView(
                        "No Scenes Yet",
                        systemImage: "photo.on.rectangle.angled",
                        description: Text("Freeze your first color moment to get started")
                    )
                } else {
                    List {
                        ForEach(filteredScenes) { scene in
                            FreezeRow(scene: scene)
                        }
                        .onDelete(perform: deleteScenes)
                    }
                }
            }
            .navigationTitle("SceneColor")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
    
    private var filteredScenes: [Scene] {
        guard let month = selectedMonth else { return appState.scenes }
        return appState.scenes.filter { Calendar.current.component(.month, from: $0.date) == month }
    }
    
    private func deleteScenes(at offsets: IndexSet) {
        for index in offsets {
            appState.deleteScene(filteredScenes[index])
        }
    }
}

/// Month filter pill button
struct MonthPill: View {
    let month: Int
    let isSelected: Bool
    let action: () -> Void
    
    private let monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                              "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    
    var body: some View {
        Button(action: action) {
            Text(monthNames[month - 1])
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    TimelineView()
        .environmentObject(AppState())
}
