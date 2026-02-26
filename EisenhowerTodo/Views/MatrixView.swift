import SwiftUI
import SwiftData

struct MatrixView: View {
    @Query(sort: \TodoItem.createdAt, order: .reverse) private var allItems: [TodoItem]
    @State private var showingAddTask = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerRow
                    .padding(.horizontal)
                    .padding(.top, 4)

                HStack(alignment: .top, spacing: 0) {
                    sideLabels
                    matrixGrid
                }
                .padding()
            }
            .navigationTitle("Eisenhower")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
        }
    }

    private var headerRow: some View {
        HStack {
            Spacer()
                .frame(width: 24)
            HStack {
                Spacer()
                Text("Urgent")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Not Urgent")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
    }

    private var sideLabels: some View {
        VStack {
            Spacer()
            Text("Important")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .rotationEffect(.degrees(-90))
                .fixedSize()
            Spacer()
            Text("Not Important")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .rotationEffect(.degrees(-90))
                .fixedSize()
            Spacer()
        }
        .frame(width: 24)
    }

    private var matrixGrid: some View {
        let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Quadrant.allCases) { quadrant in
                NavigationLink {
                    QuadrantDetailView(quadrant: quadrant)
                } label: {
                    QuadrantCard(
                        quadrant: quadrant,
                        total: countFor(quadrant),
                        completed: completedCountFor(quadrant)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func countFor(_ quadrant: Quadrant) -> Int {
        allItems.filter { $0.quadrantRawValue == quadrant.rawValue && !$0.isCompleted }.count
    }

    private func completedCountFor(_ quadrant: Quadrant) -> Int {
        allItems.filter { $0.quadrantRawValue == quadrant.rawValue && $0.isCompleted }.count
    }
}

private struct QuadrantCard: View {
    let quadrant: Quadrant
    let total: Int
    let completed: Int

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: quadrant.icon)
                .font(.title2)

            Text(quadrant.title)
                .font(.headline)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(quadrant.localizedTitle)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
                .opacity(0.85)

            Spacer(minLength: 0)

            Text("\(total)")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("\(completed) done")
                .font(.caption2)
                .opacity(0.7)
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(quadrant.color.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
    }
}
