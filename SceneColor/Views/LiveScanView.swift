import SwiftUI

/// Main live camera scanning view
struct LiveScanView: View {
  @EnvironmentObject var appState: AppState
  @StateObject private var cameraVM = CameraViewModel()

  // UI State
  @State private var dragOffset: CGFloat = 0
  @State private var navOpacity: Double = 1.0
  @State private var inactivityTimer: Timer?

  var body: some View {
    ZStack {
      // Camera Feed or Simulator Fallback
      Group {
        if cameraVM.isSimulator {
          simulatorFallback
        } else {
          CameraPreview(cameraService: cameraVM.cameraService)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
          if cameraVM.mode == .live {
            resetInactivityTimer()
          }
        }
      }
      .onLongPressGesture(minimumDuration: 0.5) {
        if cameraVM.mode == .live {
          cameraVM.freeze()
          hapticFeedback(style: .heavy)
          resetInactivityTimer()
        }
      }

      // Central Info (Simulator Mode) - Subtler and Centered
      if cameraVM.isSimulator {
        Text("Simulator Mode")
          .font(.system(size: 16, weight: .semibold, design: .rounded))
          .foregroundColor(.white.opacity(0.8))
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(.ultraThinMaterial.opacity(0.5))
          .clipShape(Capsule())
          .opacity(navOpacity)
          .scaleEffect(navOpacity > 0.5 ? 1.0 : 0.9)
      }

      // Blob Overlay (Visible only in Live mode)
      if cameraVM.mode == .live {
        BlobOverlay(extractedColors: cameraVM.extractedColors)
          .transition(.opacity)
      }

      // Main UI Overlay
      VStack {
        HStack {
          if cameraVM.mode == .live {
            // Switch Camera Button (Matching Reference Style)
            Button {
              cameraVM.switchCamera()
              resetInactivityTimer()
            } label: {
              Image(systemName: "camera.badge.ellipsis")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .padding(12)
                .background(Circle().fill(.white.opacity(0.25)))  // More visible
                .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 0.5))
            }
            .padding(.top, 60)
            .padding(.leading, 20)
            .transition(.move(edge: .top).combined(with: .opacity))
          }

          Spacer()
        }

        Spacer()

        VStack(spacing: 24) {
          // Floating Navigation Pill
          FloatingNav(
            mode: cameraVM.mode,
            onFreeze: {
              if cameraVM.mode == .live {
                cameraVM.freeze()
                hapticFeedback(style: .medium)
              } else {
                cameraVM.unfreeze()
              }
              resetInactivityTimer()
            },
            onTimeline: {
              appState.showTimeline = true
              resetInactivityTimer()
            }
          )
          .opacity(cameraVM.mode == .dragging ? 0 : navOpacity)
          .scaleEffect(navOpacity > 0.5 ? 1.0 : 0.95)

          // Palette Dock
          PaletteDock(colors: cameraVM.currentColors) { colorInfo in
            UIPasteboard.general.string = colorInfo.hex
            hapticFeedback(style: .light)
            resetInactivityTimer()
          }
          .opacity(navOpacity)
          .scaleEffect(cameraVM.mode == .dragging ? 1.05 : (navOpacity > 0.5 ? 1.0 : 0.9))
          .offset(x: dragOffset)
          .gesture(
            DragGesture()
              .onChanged { value in
                guard cameraVM.mode == .freeze || cameraVM.mode == .dragging else { return }

                if cameraVM.mode == .freeze {
                  hapticFeedback(style: .light)
                }

                cameraVM.mode = .dragging
                dragOffset = max(0, value.translation.width)
                navOpacity = 1.0
              }
              .onEnded { value in
                if dragOffset > 150 {
                  saveFreeze()
                } else {
                  withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    dragOffset = 0
                    cameraVM.mode = .freeze
                  }
                }
              }
          )
        }
        .padding(.bottom, 50)
      }

      // Liquid Sidebar
      LiquidSidebar(
        savedCount: appState.currentScene?.freezes.count ?? 0,
        dragOffset: dragOffset,
        isVisible: cameraVM.mode == .dragging || dragOffset > 0
      )
    }
    .ignoresSafeArea()
    .background(Color.black)
    .onAppear {
      cameraVM.startCamera()
      resetInactivityTimer()
    }
    .onDisappear {
      cameraVM.stopCamera()
      inactivityTimer?.invalidate()
    }
    .sheet(isPresented: $appState.showTimeline) {
      TimelineView()
    }
  }

  private func resetInactivityTimer() {
    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
      navOpacity = 1.0
    }
    inactivityTimer?.invalidate()
    inactivityTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
      DispatchQueue.main.async {
        withAnimation(.easeInOut(duration: 1.5)) {
          // Only hide if we aren't interacting and it's live
          if cameraVM.mode == .live && self.dragOffset == 0 {
            self.navOpacity = 0.0
          }
        }
      }
    }
  }

  private var simulatorFallback: some View {
    LinearGradient(
      colors: [.blue.opacity(0.3), .purple.opacity(0.3), .pink.opacity(0.3)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
    .overlay {
      if let image = cameraVM.lastCapturedImage {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .blur(radius: 5)
      }
    }
  }

  private func saveFreeze() {
    guard let freeze = cameraVM.activeFreeze else { return }

    let scene = appState.currentScene ?? appState.createNewScene(name: "New Scene")
    appState.addFreeze(freeze, to: scene)

    hapticFeedback(style: .heavy)

    // Reset state with fluid transition
    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
      dragOffset = 0
      cameraVM.unfreeze()
    }

    // Resume auto-hide
    resetInactivityTimer()
  }

  private func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.prepare()
    generator.impactOccurred()
  }
}

#Preview {
  LiveScanView()
    .environmentObject(AppState())
}
