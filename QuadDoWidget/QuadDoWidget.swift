import SwiftUI
import WidgetKit

struct QuadDoWidget: Widget {
    let kind: String = "QuadDoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodoWidgetProvider()) { entry in
            QuadDoWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color(uiColor: .systemBackground)
                }
        }
        .configurationDisplayName("QuadDo Matrix")
        .description("View and manage your tasks by priority")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

private struct QuadDoWidgetEntryView: View {
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
