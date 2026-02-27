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
    name: "QuadDo",
    targets: [
        .target(
            name: "QuadDo",
            destinations: .iOS,
            product: .app,
            bundleId: "com.tedypark.quaddo",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "QuadDo",
                "UILaunchScreen": [:],
                "UISupportedInterfaceOrientations": [
                    "UIInterfaceOrientationPortrait",
                    "UIInterfaceOrientationLandscapeLeft",
                    "UIInterfaceOrientationLandscapeRight",
                ],
            ]),
            sources: [
                "QuadDo/**",
                "Shared/**",
            ],
            resources: [
                "QuadDo/Assets.xcassets",
            ],
            entitlements: .file(path: "QuadDo/QuadDo.entitlements"),
            dependencies: [
                .target(name: "QuadDoWidget"),
            ],
            settings: .settings(base: appSettings)
        ),
        .target(
            name: "QuadDoWidget",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.tedypark.quaddo.widget",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "QuadDo Widget",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
                ],
            ]),
            sources: [
                "QuadDoWidget/**",
                "Shared/**",
            ],
            entitlements: .file(path: "QuadDoWidget/QuadDoWidget.entitlements"),
            settings: .settings(base: widgetSettings)
        ),
    ]
)
