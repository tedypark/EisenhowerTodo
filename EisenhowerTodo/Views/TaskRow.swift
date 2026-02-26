import SwiftUI
import SwiftData
import WidgetKit

struct TaskRow: View {
    @Environment(\.modelContext) private var modelContext
    let item: TodoItem

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.snappy(duration: 0.25)) {
                    item.isCompleted.toggle()
                    try? modelContext.save()
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? item.quadrant.color : .secondary)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.body)
                    .strikethrough(item.isCompleted, color: .secondary)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)

                if let dueDate = item.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundStyle(dueDate < .now && !item.isCompleted ? .red : .secondary)
                }
            }

            Spacer()

            Circle()
                .fill(item.quadrant.color)
                .frame(width: 8, height: 8)
        }
        .padding(.vertical, 2)
    }
}
