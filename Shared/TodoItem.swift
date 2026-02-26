import Foundation
import SwiftData

@Model
final class TodoItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var note: String
    var quadrantRawValue: Int
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?

    var quadrant: Quadrant {
        get { Quadrant(rawValue: quadrantRawValue) ?? .drop }
        set { quadrantRawValue = newValue.rawValue }
    }

    init(
        title: String,
        note: String = "",
        quadrant: Quadrant,
        dueDate: Date? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.note = note
        self.quadrantRawValue = quadrant.rawValue
        self.isCompleted = false
        self.createdAt = .now
        self.dueDate = dueDate
    }
}
