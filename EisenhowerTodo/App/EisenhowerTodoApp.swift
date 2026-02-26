import SwiftUI
import SwiftData

@main
struct EisenhowerTodoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
