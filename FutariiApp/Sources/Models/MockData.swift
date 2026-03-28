import Foundation

struct MockData {
    static let userHusband = User(id: UUID(), name: "Taro", role: .husband)
    static let userWife = User(id: UUID(), name: "Hanako", role: .wife)
    
    static let lifeEvents: [LifeEvent] = [
        LifeEvent(type: .preWedding, customColorHex: nil),
        LifeEvent(type: .honeymoon, customColorHex: nil),
        LifeEvent(type: .housing, customColorHex: nil)
    ]
    
    static let items: [Item] = [
        Item(
            id: UUID(),
            lifeEventId: LifeEventType.preWedding.id,
            type: .todo,
            title: "式場候補リスト作成",
            description: "ゼクシィを見て3つくらいピックアップする",
            owner: .wife,
            startAt: Date(),
            endAt: nil,
            isAllDay: true,
            status: .done,
            source: .manual,
            createdAt: Date(),
            updatedAt: Date()
        ),
        Item(
            id: UUID(),
            lifeEventId: LifeEventType.preWedding.id,
            type: .event,
            title: "ブライダルフェア（A会場）",
            description: "試食会あり。10:00集合",
            owner: .both,
            startAt: Date().addingTimeInterval(86400 * 2), // 2 days later
            endAt: Date().addingTimeInterval(86400 * 2 + 7200),
            isAllDay: false,
            status: .open,
            source: .manual,
            createdAt: Date(),
            updatedAt: Date()
        ),
        Item(
            id: UUID(),
            lifeEventId: LifeEventType.preWedding.id,
            type: .todo,
            title: "招待客リストアップ",
            description: "親族、友人、会社の順で",
            owner: .both,
            startAt: Date().addingTimeInterval(86400 * 5),
            endAt: nil,
            isAllDay: true,
            status: .open,
            source: .autoTemplate,
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
    
    static let comparison: ComparisonMatrix = {
        let cid1 = UUID()
        let cid2 = UUID()
        let crid1 = UUID()
        let crid2 = UUID()
        let crid3 = UUID()
        
        return ComparisonMatrix(
            id: UUID(),
            lifeEventId: LifeEventType.preWedding.id,
            title: "式場比較",
            createdAt: Date(),
            candidates: [
                ComparisonCandidate(id: cid1, name: "ホテルA", memo: "伝統的"),
                ComparisonCandidate(id: cid2, name: "ゲストハウスB", memo: "おしゃれ")
            ],
            criteria: [
                ComparisonCriteria(id: crid1, label: "料理", orderIndex: 0),
                ComparisonCriteria(id: crid2, label: "予算", orderIndex: 1),
                ComparisonCriteria(id: crid3, label: "雰囲気", orderIndex: 2)
            ],
            cellValues: [
                ComparisonCell(candidateId: cid1, criteriaId: crid1, score: 5, memo: "最高"),
                ComparisonCell(candidateId: cid1, criteriaId: crid2, score: 2, memo: "高い"),
                ComparisonCell(candidateId: cid1, criteriaId: crid3, score: 4, memo: "重厚"),
                ComparisonCell(candidateId: cid2, criteriaId: crid1, score: 3, memo: "普通"),
                ComparisonCell(candidateId: cid2, criteriaId: crid2, score: 4, memo: "手頃"),
                ComparisonCell(candidateId: cid2, criteriaId: crid3, score: 5, memo: "理想的")
            ]
        )
    }()
}
