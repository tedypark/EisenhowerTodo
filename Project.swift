import ProjectDescription

let swiftSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "SWIFT_STRICT_CONCURRENCY": "complete",
]

let appSettings: SettingsDictionary = swiftSettings.merging([
    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
    "GENERATE_INFOPLIST_FILE": "YES",
    "MARKETING_VERSION": "1.0.0",
    "CURRENT_PROJECT_VERSION": "1",
])

let widgetSettings: SettingsDictionary = swiftSettings.merging([
    "GENERATE_INFOPLIST_FILE": "YES",
    "MARKETING_VERSION": "1.0.0",
    "CURRENT_PROJECT_VERSION": "1",
])

let project = Project(
    name: "EisenhowerTodo",
    targets: [
        .target(
            name: "EisenhowerTodo",
            destinations: .iOS,
            product: .app,
            bundleId: "com.eisenhower.todo",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "Eisenhower",
                "UILaunchScreen": [:],
                "UISupportedInterfaceOrientations": [
                    "UIInterfaceOrientationPortrait",
                    "UIInterfaceOrientationLandscapeLeft",
                    "UIInterfaceOrientationLandscapeRight",
                ],
            ]),
            sources: [
                "EisenhowerTodo/**",
                "Shared/**",
            ],
            resources: [
                "EisenhowerTodo/Assets.xcassets",
            ],
            entitlements: .file(path: "EisenhowerTodo/EisenhowerTodo.entitlements"),
            dependencies: [
                .target(name: "EisenhowerWidget"),
            ],
            settings: .settings(base: appSettings)
        ),
        .target(
            name: "EisenhowerWidget",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.eisenhower.todo.widget",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "Eisenhower Widget",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
                ],
            ]),
            sources: [
                "EisenhowerWidget/**",
                "Shared/**",
            ],
            entitlements: .file(path: "EisenhowerWidget/EisenhowerWidget.entitlements"),
            settings: .settings(base: widgetSettings)
        ),
    ]
)
