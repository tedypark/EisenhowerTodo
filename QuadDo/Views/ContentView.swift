import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Matrix", systemImage: "square.grid.2x2.fill") {
                MatrixView()
            }

            Tab("All Tasks", systemImage: "list.bullet") {
                TaskListView()
            }
        }
    }
}
