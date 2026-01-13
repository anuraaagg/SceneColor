import Foundation

/// Represents a captured scene with frozen color moments
struct Scene: Identifiable, Codable {
    let id: UUID
    var name: String
    var date: Date
    var freezes: [Freeze]
    
    init(id: UUID = UUID(), name: String, date: Date = Date(), freezes: [Freeze] = []) {
        self.id = id
        self.name = name
        self.date = date
        self.freezes = freezes
    }
}
