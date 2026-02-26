import SwiftData
import SwiftUI
import WidgetKit

struct TodoSnapshot: Identifiable {
    let id: String
    let title: String
    let quadrantRawValue: Int
    let isCompleted: Bool
    let dueDate: Date?

    var quadrant: Quadrant {
        Quadrant(rawValue: quadrantRawValue) ?? .drop
    }
}

struct TodoWidgetEntry: TimelineEntry {
    let date: Date
    let todos: [TodoSnapshot]
}

struct TodoWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodoWidgetEntry {
        TodoWidgetEntry(date: .now, todos: Self.sampleTodos)
    }

    func getSnapshot(in context: Context, completion: @escaping @Sendable (TodoWidgetEntry) -> Void) {
        let todos = Self.fetchIncompleteTodos()
        completion(TodoWidgetEntry(date: .now, todos: todos.isEmpty ? Self.sampleTodos : todos))
    }

    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<TodoWidgetEntry>) -> Void) {
        let todos = Self.fetchIncompleteTodos()
        let entry = TodoWidgetEntry(date: .now, todos: todos)
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: .now) ?? .now.addingTimeInterval(900)
        completion(Timeline(entries: [entry], policy: .after(refreshDate)))
    }

    private static func fetchIncompleteTodos() -> [TodoSnapshot] {
        let context = ModelContext(sharedModelContainer)
        let predicate = #Predicate<TodoItem> { !$0.isCompleted }
        let descriptor = FetchDescriptor<TodoItem>(
            predicate: predicate,
            sortBy: [SortDescriptor(\TodoItem.createdAt, order: .forward)]
        )

        guard let items = try? context.fetch(descriptor) else {
            return []
        }

        return items.map {
            TodoSnapshot(
                id: $0.id.uuidString,
                title: $0.title,
                quadrantRawValue: $0.quadrantRawValue,
                isCompleted: $0.isCompleted,
                dueDate: $0.dueDate
            )
        }
    }

    private static let sampleTodos: [TodoSnapshot] = [
        TodoSnapshot(id: UUID().uuidString, title: "Finalize sprint report", quadrantRawValue: Quadrant.doFirst.rawValue, isCompleted: false, dueDate: nil),
        TodoSnapshot(id: UUID().uuidString, title: "Plan next week roadmap", quadrantRawValue: Quadrant.schedule.rawValue, isCompleted: false, dueDate: nil),
        TodoSnapshot(id: UUID().uuidString, title: "Reply to vendor email", quadrantRawValue: Quadrant.delegate.rawValue, isCompleted: false, dueDate: nil),
        TodoSnapshot(id: UUID().uuidString, title: "Unsubscribe unused newsletters", quadrantRawValue: Quadrant.drop.rawValue, isCompleted: false, dueDate: nil)
    ]
}
