import SwiftUI
import WidgetKit

struct EisenhowerWidget: Widget {
    let kind: String = "EisenhowerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodoWidgetProvider()) { entry in
            EisenhowerWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color(uiColor: .systemBackground)
                }
        }
        .configurationDisplayName("Eisenhower Matrix")
        .description("View and manage your tasks by priority")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

private struct EisenhowerWidgetEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    let entry: TodoWidgetEntry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}
