import SwiftUI
import SwiftData
import WidgetKit

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.createdAt, order: .reverse) private var allItems: [TodoItem]
    @State private var showingAddTask = false
    @State private var searchText = ""

    private var filteredItems: [TodoItem] {
        guard !searchText.isEmpty else { return allItems }
        return allItems.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(Quadrant.allCases) { quadrant in
                    let sectionItems = filteredItems.filter { $0.quadrantRawValue == quadrant.rawValue }

                    if !sectionItems.isEmpty {
                        Section {
                            ForEach(sectionItems) { item in
                                TaskRow(item: item)
                            }
                            .onDelete { offsets in
                                deleteItems(sectionItems, at: offsets)
                            }
                        } header: {
                            Label(quadrant.title, systemImage: quadrant.icon)
                                .foregroundStyle(quadrant.color)
                                .fontWeight(.semibold)
                        }
                    }
                }

                if filteredItems.isEmpty {
                    ContentUnavailableView(
                        searchText.isEmpty ? "No Tasks Yet" : "No Results",
                        systemImage: searchText.isEmpty ? "checklist" : "magnifyingglass",
                        description: Text(
                            searchText.isEmpty
                                ? "Tap + to create your first task"
                                : "No tasks matching \"\(searchText)\""
                        )
                    )
                }
            }
            .navigationTitle("All Tasks")
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
                AddTaskView()
            }
        }
    }

    private func deleteItems(_ sectionItems: [TodoItem], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sectionItems[index])
        }
        try? modelContext.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
