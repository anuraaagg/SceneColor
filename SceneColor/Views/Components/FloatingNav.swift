import SwiftUI

struct FloatingNav: View {
  let mode: CameraViewModel.AppMode
  var onFreeze: () -> Void
  var onTimeline: () -> Void

  var body: some View {
    HStack(spacing: 24) {
      // Live Button (Visible only in live)
      if mode == .live {
        Image(systemName: "sparkles")
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(.primary)
          .transition(.scale.combined(with: .opacity))
      }

      // Freeze Button (Primary Action)
      Button(action: onFreeze) {
        ZStack {
          Circle()
            .fill(Color.primary.opacity(0.1))
            .frame(width: 44, height: 44)

          Circle()
            .fill(Color.primary)
            .frame(width: 12, height: 12)
        }
      }

      // Timeline Button (Visible only in live)
      if mode == .live {
        Button(action: onTimeline) {
          Image(systemName: "clock")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.primary)
        }
        .transition(.scale.combined(with: .opacity))
      }
    }
    .padding(.horizontal, mode == .live ? 24 : 12)
    .padding(.vertical, 8)
    .background {
      ZStack {
        Capsule()
          .fill(.ultraThinMaterial)

        Capsule()
          .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
      }
      .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 10)
    }
    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: mode)
  }
}

#Preview {
  ZStack {
    Color.gray
    FloatingNav(
      mode: .live,
      onFreeze: {},
      onTimeline: {}
    )
  }
}
