# QuadDo

Quadrant-based priority TODO app with interactive widgets.

> Organize tasks by urgency and importance using the Eisenhower Matrix — right on your home screen.

## Features

### Eisenhower Matrix

| | Urgent | Not Urgent |
|---|---|---|
| **Important** | Do First | Schedule |
| **Not Important** | Delegate | Drop |

- 2x2 visual grid with color-coded quadrants
- Task counts (total / completed) per quadrant
- Tap a quadrant to see its task list

### Task Management

- Create tasks with title, note, quadrant, and optional due date
- Toggle completion with instant visual feedback
- Swipe to delete
- Search across all tasks or within a quadrant
- Grouped list view (all tasks by quadrant)

### Interactive Widgets

| Size | What it shows |
|------|---------------|
| **Small** | 2x2 grid with task counts per quadrant |
| **Medium** | "Do First" tasks with toggle buttons |
| **Large** | Full matrix with up to 3 tasks per quadrant |

- Complete tasks directly from the widget (App Intents)
- Auto-refresh every 15 minutes
- Shared database via App Groups — changes sync instantly

## Quadrant Colors

| Quadrant | Color | Hex |
|----------|-------|-----|
| Do First | Green | `#6B9E7D` |
| Schedule | Salmon | `#E8846B` |
| Delegate | Blue | `#5B7FCC` |
| Drop | Red | `#E86B6B` |

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift 6.0 (strict concurrency) |
| UI | SwiftUI |
| Persistence | SwiftData |
| Data Sharing | App Groups |
| Widgets | WidgetKit + App Intents |
| Project | Tuist 4.x |
| Target | iOS 26.0+ |

No external dependencies. Apple frameworks only.

## Architecture

```
QuadDo/
├── Project.swift                    # Tuist config (2 targets)
├── Tuist/Package.swift              # Dependency manifest
├── Shared/                          # Compiled into both targets
│   ├── TodoItem.swift              # @Model — SwiftData entity
│   ├── Quadrant.swift              # Enum with color, icon, localization
│   └── SharedModelContainer.swift  # ModelContainer + App Group fallback
├── QuadDo/                          # Main app target
│   ├── App/QuadDoApp.swift         # @main entry point
│   ├── Views/
│   │   ├── ContentView.swift       # TabView (Matrix / List)
│   │   ├── MatrixView.swift        # 2x2 grid
│   │   ├── QuadrantDetailView.swift
│   │   ├── AddTaskView.swift
│   │   ├── TaskListView.swift
│   │   └── TaskRow.swift
│   └── QuadDo.entitlements
└── QuadDoWidget/                    # Widget extension target
    ├── QuadDoWidget.swift           # Widget config (3 sizes)
    ├── QuadDoWidgetBundle.swift
    ├── Provider/TodoWidgetProvider.swift
    ├── Views/
    │   ├── SmallWidgetView.swift
    │   ├── MediumWidgetView.swift
    │   └── LargeWidgetView.swift
    ├── Intents/ToggleTodoIntent.swift
    └── QuadDoWidget.entitlements
```

### Data Flow

```
User creates task → SwiftData (shared container)
                          ↓
                    App Groups sync
                          ↓
Widget reads → TodoWidgetProvider → Renders timeline
Widget tap  → ToggleTodoIntent  → Toggles completion → Reloads widget
```

## Getting Started

### Prerequisites

- Xcode 26.0+
- [Tuist](https://tuist.io) 4.x (`brew install tuist`)
- iOS 26.0+ simulator or device

### Setup

```bash
# Clone
git clone https://github.com/tedypark/QuadDo.git
cd QuadDo

# Init submodules (ios-standards)
git submodule update --init --recursive

# Install dependencies & generate project
tuist install
tuist generate

# Build from CLI (optional)
DEVELOPER_DIR=/Applications/Xcode-26.1.1.app/Contents/Developer \
xcodebuild build -project QuadDo.xcodeproj -target QuadDo \
-sdk iphonesimulator CODE_SIGNING_ALLOWED=NO
```

### Add Widget

1. Build & run QuadDo on simulator/device
2. Long-press home screen → tap **+**
3. Search "QuadDo" → choose Small, Medium, or Large

## Bundle IDs

| Target | Bundle ID |
|--------|-----------|
| App | `com.tedypark.quaddo` |
| Widget | `com.tedypark.quaddo.widget` |
| App Group | `group.com.tedypark.quaddo` |

## Shared Standards

This project uses [tedypark/ios-standards](https://github.com/tedypark/ios-standards) as a git submodule at `.claude/ios-standards/` for shared iOS development guidelines.

```bash
# Update standards
cd .claude/ios-standards && git pull origin main
cd ../.. && git add .claude/ios-standards && git commit -m "chore: update ios-standards"
```

## License

MIT
