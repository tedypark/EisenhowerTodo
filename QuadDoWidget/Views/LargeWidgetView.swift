import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    let entry: TodoWidgetEntry

    private let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Quadrant.allCases) { quadrant in
                quadrantSection(for: quadrant)
            }
        }
        .padding(10)
    }

    private func quadrantSection(for quadrant: Quadrant) -> some View {
        let tasks = tasks(for: quadrant)
        let visibleTasks = Array(tasks.prefix(3))
        let overflow = max(0, tasks.count - visibleTasks.count)

        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: quadrant.icon)
                    .font(.system(size: 11, weight: .bold))
                Text(quadrant.title)
                    .font(.system(size: 12, weight: .bold))
                Spacer(minLength: 0)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(quadrant.color)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            if visibleTasks.isEmpty {
                Text("No tasks")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(visibleTasks) { todo in
                        HStack(spacing: 6) {
                            Button(intent: ToggleTodoIntent(taskID: todo.id)) {
                                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(todo.isCompleted ? quadrant.color : .secondary)
                            }
                            .buttonStyle(.plain)

                            Text(todo.title)
                                .font(.system(size: 11, weight: .medium))
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }

            if overflow > 0 {
                Text("+\(overflow) more")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }

            Spacer(minLength: 0)
        }
        .padding(8)
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func tasks(for quadrant: Quadrant) -> [TodoSnapshot] {
        entry.todos.filter { $0.quadrantRawValue == quadrant.rawValue && !$0.isCompleted }
    }
}
