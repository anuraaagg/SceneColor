import SwiftUI

/// Main live camera scanning view
struct LiveScanView: View {
  @EnvironmentObject var appState: AppState
  @StateObject private var cameraVM = CameraViewModel()

  var body: some View {
    ZStack {
      // Camera feed or simulator fallback
      if cameraVM.isSimulator {
        simulatorFallback
      } else {
        CameraPreview(cameraService: cameraVM.cameraService)
      }

      // UI Overlay
      VStack {
        HStack {
          // Switch Camera Button
          Button {
            cameraVM.switchCamera()
          } label: {
            Image(systemName: "camera.rotate")
              .font(.title2)
              .foregroundColor(.white)
              .padding()
              .background(Color.black.opacity(0.3))
              .clipShape(Circle())
          }
          .padding()

          Spacer()

          // Timeline button
          Button {
            appState.showTimeline = true
          } label: {
            Image(systemName: "clock")
              .font(.title2)
              .foregroundColor(.white)
              .padding()
              .background(Color.black.opacity(0.3))
              .clipShape(Circle())
          }
          .padding()
        }

        Spacer()

        // Palette dock
        HStack(spacing: 12) {
          if cameraVM.currentColors.isEmpty {
            ForEach(0..<5) { _ in
              RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 60, height: 60)
            }
          } else {
            ForEach(cameraVM.currentColors) { colorInfo in
              RoundedRectangle(cornerRadius: 12)
                .fill(colorInfo.color)
                .frame(width: 60, height: 60)
            }
          }
        }
        .padding(.horizontal)
        .padding(.bottom, 40)
      }
    }
    .ignoresSafeArea()
    .onAppear {
      cameraVM.startCamera()
    }
    .onDisappear {
      cameraVM.stopCamera()
    }
    .sheet(isPresented: $appState.showTimeline) {
      TimelineView()
    }
  }

  // Fallback UI for simulator
  private var simulatorFallback: some View {
    ZStack {
      LinearGradient(
        colors: [.blue, .purple, .pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .opacity(0.6)

      VStack {
        Text("Simulator Mode")
          .font(.headline)
          .foregroundColor(.white)
        Text("Real camera feed is unavailable on simulator")
          .font(.caption)
          .foregroundColor(.white.opacity(0.8))
      }
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
