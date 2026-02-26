import Foundation
import SwiftData

let appGroupID = "group.com.eisenhower.todo"

let sharedModelContainer: ModelContainer = {
    let schema = Schema([TodoItem.self])

    let config: ModelConfiguration
    if let appGroupURL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: appGroupID
    ) {
        let storeURL = appGroupURL.appendingPathComponent("EisenhowerTodo.sqlite")
        config = ModelConfiguration(schema: schema, url: storeURL)
    } else {
        config = ModelConfiguration(schema: schema)
    }

    do {
        return try ModelContainer(for: schema, configurations: [config])
    } catch {
        fatalError("Failed to create ModelContainer: \(error)")
    }
}()
