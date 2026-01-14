import SwiftUI

struct PaletteDock: View {
  let colors: [ColorInfo]
  var onTileTap: (ColorInfo) -> Void

  var body: some View {
    HStack(spacing: 12) {
      if colors.isEmpty {
        // Placeholder tiles
        ForEach(0..<5) { _ in
          ColorTile(color: Color.secondary.opacity(0.1))
        }
      } else {
        ForEach(colors) { colorInfo in
          ColorTile(color: colorInfo.color)
            .onTapGesture {
              onTileTap(colorInfo)
            }
        }
      }
    }
  }
}

struct ColorTile: View {
  let color: Color

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(color)
        .frame(width: 64, height: 64)

      RoundedRectangle(cornerRadius: 16)
        .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
    }
    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
  }
}

#Preview {
  ZStack {
    Color.gray
    PaletteDock(
      colors: [
        ColorInfo(hex: "#FF0000", name: "Red", r: 255, g: 0, b: 0),
        ColorInfo(hex: "#00FF00", name: "Green", r: 0, g: 255, b: 0),
        ColorInfo(hex: "#0000FF", name: "Blue", r: 0, g: 0, b: 255),
      ],
      onTileTap: { _ in }
    )
  }
}
