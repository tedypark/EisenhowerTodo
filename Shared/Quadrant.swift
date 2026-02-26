import Foundation
import SwiftUI

enum Quadrant: Int, Codable, CaseIterable, Identifiable, Sendable {
    case doFirst = 0
    case schedule = 1
    case delegate = 2
    case drop = 3

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .doFirst:  "Do"
        case .schedule: "Schedule"
        case .delegate: "Delegate"
        case .drop:     "Drop"
        }
    }

    var subtitle: String {
        switch self {
        case .doFirst:  "Urgent & Important"
        case .schedule: "Not Urgent & Important"
        case .delegate: "Urgent & Not Important"
        case .drop:     "Not Urgent & Not Important"
        }
    }

    var localizedTitle: String {
        switch self {
        case .doFirst:  "긴급하면서 중요한 일"
        case .schedule: "중요하지만, 급하지 않은 일"
        case .delegate: "중요하지 않지만, 급한 일"
        case .drop:     "중요하지도, 급하지도 않은 일"
        }
    }

    var icon: String {
        switch self {
        case .doFirst:  "flame.fill"
        case .schedule: "calendar.badge.clock"
        case .delegate: "person.2.fill"
        case .drop:     "trash.fill"
        }
    }

    var color: Color {
        switch self {
        case .doFirst:  Color(red: 107/255, green: 158/255, blue: 125/255)
        case .schedule: Color(red: 232/255, green: 132/255, blue: 107/255)
        case .delegate: Color(red: 91/255,  green: 127/255, blue: 204/255)
        case .drop:     Color(red: 232/255, green: 107/255, blue: 107/255)
        }
    }

    var isUrgent: Bool {
        self == .doFirst || self == .delegate
    }

    var isImportant: Bool {
        self == .doFirst || self == .schedule
    }
}

