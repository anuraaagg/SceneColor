import Foundation

/// Represents a captured scene with frozen color moments
struct CaptureScene: Identifiable, Codable {
  let id: UUID
  var name: String
  var createdAt: Date
  var freezes: [Freeze]

  init(id: UUID = UUID(), name: String, createdAt: Date = Date(), freezes: [Freeze] = []) {
    self.id = id
    self.name = name
    self.createdAt = createdAt
    self.freezes = freezes
  }
}
