import SwiftUI

struct DetailOverlay: View {
  let freeze: Freeze
  var onClose: () -> Void

  var body: some View {
    ZStack {
      // Background dimming
      Color.black.opacity(0.8)
        .ignoresSafeArea()
        .onTapGesture { onClose() }

      VStack(spacing: 24) {
        // Frame Image
        if let image = freeze.image {
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(16)
            .padding()
        } else {
          RoundedRectangle(cornerRadius: 16)
            .fill(Color.secondary)
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }

        // Palette
        HStack(spacing: 12) {
          ForEach(freeze.palette) { colorInfo in
            VStack(spacing: 8) {
              RoundedRectangle(cornerRadius: 8)
                .fill(colorInfo.color)
                .frame(width: 50, height: 50)

              Text(colorInfo.hex)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.white.opacity(0.8))
            }
          }
        }

        Text(freeze.createdAt, style: .time)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding()
    }
  }
}

#Preview {
  DetailOverlay(
    freeze: Freeze(
      image: UIImage(),
      palette: [
        ColorInfo(hex: "#FF5733", name: "Red", r: 255, g: 87, b: 51)
      ]),
    onClose: {}
  )
}
