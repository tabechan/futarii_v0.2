import Foundation
import SwiftUI

// MARK: - User
enum UserRole: String, Codable, CaseIterable {
    case husband
    case wife
}

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var role: UserRole
}

// MARK: - Life Event
enum LifeEventType: String, Codable, CaseIterable, Identifiable {
    case preWedding = "結婚前準備"
    case honeymoon = "新婚旅行"
    case fertility = "妊活"
    case preChildbirth = "出産準備"
    case parenting = "育児"
    case nurserySearch = "保活"
    case housing = "住宅関連"
    case education = "教育計画"
    case car = "車"
    
    var id: String { self.rawValue }
    
    // Default Colors for MVP (User can customize later)
    var defaultColor: Color {
        switch self {
        case .preWedding: return Color(hex: "F4A2A2") // Pinkish
        case .honeymoon: return Color(hex: "88CCCA") // Teal
        case .fertility: return Color(hex: "A0D468") // Green
        case .preChildbirth: return Color(hex: "FFCE54") // Yellow
        case .parenting: return Color(hex: "AC92EC") // Purple
        case .nurserySearch: return Color(hex: "EC87C0") // Magenta
        case .housing: return Color(hex: "5D9CEC") // Blue
        case .education: return Color(hex: "4A89DC") // Dark Blue
        case .car: return Color(hex: "E9573F") // Red
        }
    }
}

struct LifeEvent: Identifiable, Codable {
    let id: String // Use LifeEventType.rawValue
    var type: LifeEventType
    var customColorHex: String?
    
    init(type: LifeEventType, customColorHex: String? = nil) {
        self.id = type.rawValue
        self.type = type
        self.customColorHex = customColorHex
    }
    
    var displayColor: Color {
        if let hex = customColorHex {
            return Color(hex: hex)
        }
        return type.defaultColor
    }
}

// MARK: - Item (ToDo / Event)
enum ItemType: String, Codable {
    case todo
    case event
}

enum ItemOwner: String, Codable, CaseIterable {
    case husband
    case wife
    case both
    
    var label: String {
        switch self {
        case .husband: return "夫"
        case .wife: return "妻"
        case .both: return "共同"
        }
    }
}

enum ItemStatus: String, Codable {
    case open
    case done
    case archived
}

enum ItemSource: String, Codable {
    case manual
    case autoTemplate = "auto_template"
    case autoLearning = "auto_learning"
}

struct Item: Identifiable, Codable {
    let id: UUID
    var lifeEventId: String
    var type: ItemType
    var title: String
    var description: String?
    
    var owner: ItemOwner
    
    var startAt: Date
    var endAt: Date?
    var isAllDay: Bool
    
    var status: ItemStatus
    var source: ItemSource
    
    var createdAt: Date
    var updatedAt: Date
}

// MARK: - Comparison (Candidate & Criteria)
struct ComparisonMatrix: Identifiable, Codable {
    let id: UUID
    var lifeEventId: String
    var title: String
    var createdAt: Date
    
    var candidates: [ComparisonCandidate]
    var criteria: [ComparisonCriteria]
    var cellValues: [ComparisonCell] // (candidateId, criteriaId) -> Score
}

struct ComparisonCandidate: Identifiable, Codable {
    let id: UUID
    var name: String
    var memo: String?
}

struct ComparisonCriteria: Identifiable, Codable {
    let id: UUID
    var label: String
    var orderIndex: Int
}

struct ComparisonCell: Codable {
    var candidateId: UUID
    var criteriaId: UUID
    var score: Int // 0-5
    var memo: String?
}
