import Foundation
import SwiftUI

// MARK: - Configuration
enum Config {
  // 優先順位: 1.UserDefaults(設定UI) > 2.Secrets.plist(ローカルファイル) > 3.環境変数
  static var aiApiKey: String {
    // 1. 設定画面(UserDefaults)から取得
    if let userKey = UserDefaults.standard.string(forKey: "AI_API_KEY"), !userKey.isEmpty {
      return userKey
    }

    // 2. Secrets.plist (Git管理外のローカルファイル) から取得
    if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
      let dict = NSDictionary(contentsOfFile: path),
      let key = dict["AI_API_KEY"] as? String, !key.isEmpty
    {
      return key
    }

    // 3. プロセス環境変数から取得
    if let envKey = ProcessInfo.processInfo.environment["AI_API_KEY"], !envKey.isEmpty {
      return envKey
    }

    return ""
  }
}

// MARK: - User
enum UserRole: String, Codable, CaseIterable {
  case husband
  case wife

  var label: String {
    switch self {
    case .husband: return "夫"
    case .wife: return "妻"
    }
  }
}

struct User: Identifiable, Codable {
  let id: UUID
  var name: String
  var role: UserRole
  var loadStatus: PartnerLoadStatus = .goingWell
}

// MARK: - Partner Load Status
enum PartnerLoadStatus: String, Codable, CaseIterable {
  case struggling = "struggling"  // 😫
  case goingWell = "going_well"  // 🙂
  case available = "available"  // 😄

  var emoji: String {
    switch self {
    case .struggling: return "😫"
    case .goingWell: return "🙂"
    case .available: return "😄"
    }
  }

  var label: String {
    switch self {
    case .struggling: return "今いろいろ大変…"
    case .goingWell: return "いつも通りだよ"
    case .available: return "手伝えることがあったら言って！"
    }
  }
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
    case .preWedding: return Color(hex: "F4A2A2")  // Pinkish
    case .honeymoon: return Color(hex: "88CCCA")  // Teal
    case .fertility: return Color(hex: "A0D468")  // Green
    case .preChildbirth: return Color(hex: "FFCE54")  // Yellow
    case .parenting: return Color(hex: "AC92EC")  // Purple
    case .nurserySearch: return Color(hex: "EC87C0")  // Magenta
    case .housing: return Color(hex: "5D9CEC")  // Blue
    case .education: return Color(hex: "4A89DC")  // Dark Blue
    case .car: return Color(hex: "E9573F")  // Red
    }
  }
}

struct LifeEvent: Identifiable, Codable {
  let id: String  // Use LifeEventType.rawValue
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
  var recurrenceRule: String?  // "weekly", "monthly", etc. for demo

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
  var cellValues: [ComparisonCell]  // (candidateId, criteriaId) -> Score
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
  var score: Int  // 0-5
  var memo: String?
}

struct QuizQuestion: Identifiable, Codable {
  let id: UUID
  var question: String
  var options: [String]
  var answerIndex: Int
  var explanation: String
}

struct ActionableToDo: Identifiable, Codable {
  let id: UUID
  var title: String
  var description: String
}

// MARK: - Learning Content
struct LearningContent: Identifiable, Codable {
  let id: UUID
  var title: String
  var description: String
  var body: String
  var quizzes: [QuizQuestion]
  var recommendedToDos: [ActionableToDo]
  var lifeEventId: String
  var sourceUrl: String? = nil
  var completedBy: Set<UUID>  // Set of User IDs
  var updatedAt: Date
}
