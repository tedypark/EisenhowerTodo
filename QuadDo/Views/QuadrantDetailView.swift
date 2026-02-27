import SwiftUI
import SwiftData
import WidgetKit

struct QuadrantDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TodoItem]
    @State private var showingAddTask = false
    @State private var searchText = ""

    let quadrant: Quadrant

    init(quadrant: Quadrant) {
        self.quadrant = quadrant
        let rawValue = quadrant.rawValue
        _items = Query(
            filter: #Predicate<TodoItem> { $0.quadrantRawValue == rawValue },
            sort: \TodoItem.createdAt,
            order: .reverse
        )
    }

    private var filteredItems: [TodoItem] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List {
            if filteredItems.isEmpty {
                ContentUnavailableView(
                    searchText.isEmpty ? "No Tasks" : "No Results",
                    systemImage: searchText.isEmpty ? quadrant.icon : "magnifyingglass",
                    description: Text(
                        searchText.isEmpty
                            ? "Tap + to add a task to \(quadrant.title)"
                            : "No tasks matching \"\(searchText)\""
                    )
                )
            } else {
                ForEach(filteredItems) { item in
                    TaskRow(item: item)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .navigationTitle(quadrant.title)
        .searchable(text: $searchText, prompt: "Search tasks")
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
            AddTaskView(initialQuadrant: quadrant)
        }
        .tint(quadrant.color)
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredItems[index])
        }
        try? modelContext.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
