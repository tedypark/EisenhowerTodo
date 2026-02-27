import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    let entry: TodoWidgetEntry

    private let columns = [GridItem(.flexible(), spacing: 6), GridItem(.flexible(), spacing: 6)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(Quadrant.allCases) { quadrant in
                quadrantCell(for: quadrant)
            }
        }
        .padding(8)
    }

    private func quadrantCell(for quadrant: Quadrant) -> some View {
        VStack(spacing: 2) {
            Image(systemName: quadrant.icon)
                .font(.system(size: 12, weight: .semibold))
            Text("\(count(for: quadrant))")
                .font(.system(size: 16, weight: .bold))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, minHeight: 52)
        .background(quadrant.color)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func count(for quadrant: Quadrant) -> Int {
        entry.todos.filter { $0.quadrantRawValue == quadrant.rawValue && !$0.isCompleted }.count
    }
}
