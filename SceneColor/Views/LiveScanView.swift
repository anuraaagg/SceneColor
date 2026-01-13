import SwiftUI

/// Main live camera scanning view
struct LiveScanView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var cameraVM = CameraViewModel()
    
    var body: some View {
        ZStack {
            // Camera feed placeholder
            Color.black
                .overlay(
                    Text("Camera Feed")
                        .foregroundColor(.white)
                        .font(.title)
                )
            
            VStack {
                Spacer()
                
                // Palette dock placeholder
                HStack(spacing: 12) {
                    ForEach(0..<5) { i in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.random)
                            .frame(width: 60, height: 60)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            
            // Timeline button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        appState.showTimeline = true
                    } label: {
                        Image(systemName: "clock")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $appState.showTimeline) {
            TimelineView()
        }
    }
}

// Helper extension for random colors (temporary)
extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

#Preview {
    LiveScanView()
        .environmentObject(AppState())
}
