import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    let entry: TodoWidgetEntry

    private var doFirstTodos: [TodoSnapshot] {
        entry.todos.filter { $0.quadrantRawValue == Quadrant.doFirst.rawValue && !$0.isCompleted }
    }

    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 6) {
                Image(systemName: Quadrant.doFirst.icon)
                    .font(.system(size: 20, weight: .bold))
                Text(Quadrant.doFirst.title)
                    .font(.system(size: 20, weight: .heavy))
                Text("Urgent")
                    .font(.system(size: 11, weight: .medium))
                    .opacity(0.9)
            }
            .foregroundStyle(.white)
            .frame(minWidth: 78, maxWidth: 78, maxHeight: .infinity)
            .background(Quadrant.doFirst.color)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            if doFirstTodos.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("All clear")
                        .font(.system(size: 15, weight: .semibold))
                    Text("No urgent and important tasks right now.")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(doFirstTodos.prefix(4))) { todo in
                        HStack(spacing: 8) {
                            Button(intent: ToggleTodoIntent(taskID: todo.id)) {
                                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(todo.isCompleted ? Quadrant.doFirst.color : .secondary)
                            }
                            .buttonStyle(.plain)

                            Text(todo.title)
                                .font(.system(size: 13, weight: .medium))
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(10)
    }
}
