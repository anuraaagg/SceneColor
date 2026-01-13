import SwiftUI
import UIKit

/// Row displaying a freeze in the timeline
struct FreezeRow: View {
  let scene: CaptureScene

  private var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "EEE dd"
    return df
  }

  var body: some View {
    HStack(alignment: .center, spacing: 16) {
      // Date
      Text(dateFormatter.string(from: scene.date).uppercased())
        .font(.caption)
        .foregroundStyle(.secondary)
        .frame(width: 50, alignment: .leading)

      // Scene name
      Text(scene.name)
        .font(.body)

      Spacer()

      // Color dots
      if let firstFreeze = scene.freezes.first {
        HStack(spacing: 4) {
          ForEach(firstFreeze.palette.prefix(5)) { colorInfo in
            Circle()
              .fill(colorInfo.color)
              .frame(width: 12, height: 12)
          }
        }
      }
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  List {
    FreezeRow(
      scene: CaptureScene(
        name: "Morning Cafe",
        date: Date(),
        freezes: [
          Freeze(
            image: UIImage(systemName: "photo")!,
            palette: [
              ColorInfo(hex: "#FF5733", name: "Red", r: 255, g: 87, b: 51),
              ColorInfo(hex: "#3498DB", name: "Blue", r: 52, g: 152, b: 219),
              ColorInfo(hex: "#2ECC71", name: "Green", r: 46, g: 204, b: 113),
              ColorInfo(hex: "#F39C12", name: "Orange", r: 243, g: 156, b: 18),
              ColorInfo(hex: "#9B59B6", name: "Purple", r: 155, g: 89, b: 182),
            ]
          )
        ]
      ))
  }
}
