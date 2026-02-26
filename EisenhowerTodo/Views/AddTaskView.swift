import SwiftUI
import SwiftData
import WidgetKit

struct AddTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var initialQuadrant: Quadrant?

    @State private var title = ""
    @State private var note = ""
    @State private var selectedQuadrant: Quadrant = .doFirst
    @State private var hasDueDate = false
    @State private var dueDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Task title", text: $title)

                    TextField("Note (optional)", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Quadrant") {
                    Picker("Priority", selection: $selectedQuadrant) {
                        ForEach(Quadrant.allCases) { q in
                            Label(q.title, systemImage: q.icon)
                                .tag(q)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section {
                    Toggle("Due Date", isOn: $hasDueDate.animation(.snappy))

                    if hasDueDate {
                        DatePicker(
                            "Date",
                            selection: $dueDate,
                            in: Date()...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let initialQuadrant {
                    selectedQuadrant = initialQuadrant
                }
            }
        }
    }

    private func save() {
        let newItem = TodoItem(
            title: title.trimmingCharacters(in: .whitespaces),
            note: note.trimmingCharacters(in: .whitespaces),
            quadrant: selectedQuadrant,
            dueDate: hasDueDate ? dueDate : nil
        )
        modelContext.insert(newItem)
        try? modelContext.save()
        WidgetCenter.shared.reloadAllTimelines()
        dismiss()
    }
}
