import SwiftUI

struct BlobOverlay: View {
  let extractedColors: [ExtractedColor]

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(extractedColors) { extracted in
          BlobView(color: Color(extracted.color))
            .position(
              x: extracted.location.x * geometry.size.width,
              y: extracted.location.y * geometry.size.height
            )
            .animation(
              .interactiveSpring(response: 1.0, dampingFraction: 0.8), value: extracted.location)
        }
      }
    }
  }
}

struct BlobView: View {
  let color: Color
  @State private var scale: CGFloat = 1.0

  var body: some View {
    Circle()
      .fill(color)
      .frame(width: 180, height: 180)
      .blur(radius: 50)
      .opacity(0.35)
      .scaleEffect(scale)
      .onAppear {
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
          scale = 1.3
        }
      }
  }
}

#Preview {
  BlobOverlay(extractedColors: [
    ExtractedColor(color: .red, location: CGPoint(x: 0.2, y: 0.2)),
    ExtractedColor(color: .blue, location: CGPoint(x: 0.8, y: 0.8)),
  ])
}
