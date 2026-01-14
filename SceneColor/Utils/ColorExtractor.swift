import AVFoundation
import CoreImage
import CoreMedia
import CoreVideo
import UIKit

/// State for a single extracted color with its source location
struct ExtractedColor: Identifiable {
  let id = UUID()
  let color: UIColor
  let location: CGPoint  // Normalized coordinate (0-1)
}

class ColorExtractor {
  static let shared = ColorExtractor()

  private let context = CIContext(options: [.workingColorSpace: NSNull()])

  /// Extracts a palette of 5 dominant colors from a CMSampleBuffer
  func extractPalette(from sampleBuffer: CMSampleBuffer) -> [ExtractedColor] {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return [] }

    let ciImage = CIImage(cvPixelBuffer: imageBuffer)

    // 1. Downsample for performance
    let scale = 0.1
    let filter = CIFilter(name: "CILanczosScaleTransform")!
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    filter.setValue(scale, forKey: kCIInputScaleKey)
    filter.setValue(1.0, forKey: kCIInputAspectRatioKey)

    guard let outputImage = filter.outputImage else { return [] }

    // 2. Simple dominant color extraction by sampling regions
    // We'll sample 5 regions (4 corners + center) as a first pass for "blobs"
    let extent = outputImage.extent
    let points: [CGPoint] = [
      CGPoint(x: extent.midX, y: extent.midY),  // Center
      CGPoint(x: extent.minX + 10, y: extent.minY + 10),  // Top-Left
      CGPoint(x: extent.maxX - 10, y: extent.minY + 10),  // Top-Right
      CGPoint(x: extent.minX + 10, y: extent.maxY - 10),  // Bottom-Left
      CGPoint(x: extent.maxX - 10, y: extent.maxY - 10),  // Bottom-Right
    ]

    var results: [ExtractedColor] = []

    for point in points {
      let color = sampleColor(from: outputImage, at: point)
      let normalizedLocation = CGPoint(
        x: point.x / extent.width,
        y: point.y / extent.height
      )
      results.append(ExtractedColor(color: color, location: normalizedLocation))
    }

    return results
  }

  private func sampleColor(from image: CIImage, at point: CGPoint) -> UIColor {
    let rect = CGRect(origin: point, size: CGSize(width: 1, height: 1))
    var bitmap = [UInt8](repeating: 0, count: 4)

    context.render(
      image, toBitmap: &bitmap, rowBytes: 4, bounds: rect, format: .RGBA8, colorSpace: nil)

    return UIColor(
      red: CGFloat(bitmap[0]) / 255.0,
      green: CGFloat(bitmap[1]) / 255.0,
      blue: CGFloat(bitmap[2]) / 255.0,
      alpha: 1.0
    )
  }
}
