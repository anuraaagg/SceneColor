import Foundation
import UIKit

/// Represents a single frozen moment with image and color palette
struct Freeze: Identifiable, Codable {
  let id: UUID
  let imageData: Data
  let palette: [ColorInfo]
  let createdAt: Date

  init(id: UUID = UUID(), image: UIImage, palette: [ColorInfo], createdAt: Date = Date()) {
    self.id = id
    self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
    self.palette = palette
    self.createdAt = createdAt
  }

  var image: UIImage? {
    UIImage(data: imageData)
  }
}
