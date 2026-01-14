import SwiftUI

struct LiquidSidebar: View {
  let savedCount: Int
  let dragOffset: CGFloat
  let isVisible: Bool

  var body: some View {
    ZStack(alignment: .trailing) {
      if isVisible {
        LiquidShape(offset: dragOffset)
          .fill(.ultraThinMaterial)
          .overlay {
            LiquidShape(offset: dragOffset)
              .stroke(.white.opacity(0.2), lineWidth: 1)
          }
          .shadow(color: .black.opacity(0.1), radius: 10, x: -5, y: 0)

        VStack(spacing: 20) {
          ForEach(0..<min(savedCount, 5), id: \.self) { _ in
            Circle()
              .fill(Color.primary.opacity(0.8))
              .frame(width: 8, height: 8)
          }
        }
        .padding(.trailing, 16)
        .opacity(dragOffset > 20 ? 1 : 0)
        .animation(.spring(), value: dragOffset)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
    .ignoresSafeArea()
  }
}

struct LiquidShape: Shape {
  var offset: CGFloat

  var animatableData: CGFloat {
    get { offset }
    set { offset = newValue }
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()

    let width: CGFloat = max(0, offset)
    let curveControl: CGFloat = width * 1.5

    path.move(to: CGPoint(x: rect.width, y: 0))
    path.addLine(to: CGPoint(x: rect.width, y: rect.height))

    // Liquid curve
    path.addCurve(
      to: CGPoint(x: rect.width - width, y: rect.height / 2),
      control1: CGPoint(x: rect.width, y: rect.height * 0.75),
      control2: CGPoint(x: rect.width - curveControl, y: rect.height * 0.6)
    )

    path.addCurve(
      to: CGPoint(x: rect.width, y: 0),
      control1: CGPoint(x: rect.width - curveControl, y: rect.height * 0.4),
      control2: CGPoint(x: rect.width, y: rect.height * 0.25)
    )

    return path
  }
}

#Preview {
  ZStack {
    Color.gray
    LiquidSidebar(savedCount: 3, dragOffset: 100, isVisible: true)
  }
}
