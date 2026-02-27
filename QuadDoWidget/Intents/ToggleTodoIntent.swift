import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct ToggleTodoIntent: AppIntent {
    static let title: LocalizedStringResource = "Toggle Todo"
    static let isDiscoverable: Bool = false

    @Parameter(title: "Task ID")
    var taskID: String

    init() {}

    init(taskID: String) {
        self.taskID = taskID
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        let context = ModelContext(sharedModelContainer)

        guard let uuid = UUID(uuidString: taskID) else {
            return .result()
        }

        let predicate = #Predicate<TodoItem> { $0.id == uuid }
        let descriptor = FetchDescriptor<TodoItem>(predicate: predicate)

        guard let item = try? context.fetch(descriptor).first else {
            return .result()
        }

        item.isCompleted.toggle()
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
