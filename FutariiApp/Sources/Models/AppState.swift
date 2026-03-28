import Foundation
import Combine

class AppState: ObservableObject {
    // Current Context
    @Published var currentLifeEvent: LifeEvent
    @Published var currentUser: User
    
    // Data Stores
    @Published var allLifeEvents: [LifeEvent]
    @Published var items: [Item]
    @Published var comparisons: [ComparisonMatrix]
    
    // Derived Data helpers
    var currentItems: [Item] {
        items.filter { $0.lifeEventId == currentLifeEvent.id }
    }
    
    var currentComparisons: [ComparisonMatrix] {
        comparisons.filter { $0.lifeEventId == currentLifeEvent.id }
    }
    
    init(mock: Bool = false) {
        if mock {
            self.currentUser = MockData.userHusband
            self.allLifeEvents = MockData.lifeEvents
            self.currentLifeEvent = MockData.lifeEvents.first!
            self.items = MockData.items
            self.comparisons = [MockData.comparison]
        } else {
            // Initialize with empty or persisted data
            self.currentUser = User(id: UUID(), name: "User", role: .husband)
            let defaultEvent = LifeEvent(type: .preWedding, customColorHex: nil)
            self.allLifeEvents = [defaultEvent]
            self.currentLifeEvent = defaultEvent
            self.items = []
            self.comparisons = []
        }
    }
    
    func switchLifeEvent(to event: LifeEvent) {
        self.currentLifeEvent = event
    }
    
    func addItem(_ item: Item) {
        items.append(item)
    }
    
    func updateItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }
    
    func deleteItem(_ id: UUID) {
        items.removeAll { $0.id == id }
    }
}
