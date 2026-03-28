import Combine
import Foundation
import SwiftUI

class AppState: ObservableObject {
  // Auth & Partner Link
  @Published var isLoggedIn: Bool = true
  @Published var myPartnerCode: String = "482931"
  @Published var partnerLinked: Bool = true

  // Current Context
  @Published var currentLifeEvent: LifeEvent
  @Published var currentUser: User

  // Word of the Day (Demo DB)
  @Published var husbandWord: String = ""
  @Published var wifeWord: String = ""

  var myWordOfTheDay: Binding<String> {
    Binding(
      get: { self.currentUser.role == .husband ? self.husbandWord : self.wifeWord },
      set: {
        if self.currentUser.role == .husband {
          self.husbandWord = $0
        } else {
          self.wifeWord = $0
        }
      }
    )
  }

  var partnerWordOfTheDay: String {
    self.currentUser.role == .husband ? self.wifeWord : self.husbandWord
  }

  // Data Stores
  @Published var allLifeEvents: [LifeEvent]
  @Published var items: [Item]
  @Published var comparisons: [ComparisonMatrix]
  @Published var learningContents: [LearningContent]

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
      self.currentLifeEvent =
        MockData.lifeEvents.first(where: { $0.type == .fertility }) ?? MockData.lifeEvents.first!
      self.items = MockData.items
      self.comparisons = [MockData.comparison]
      self.learningContents = MockData.learningContents
    } else {
      // Initialize with all 9 life events
      let events = LifeEventType.allCases.map { LifeEvent(type: $0) }
      self.allLifeEvents = events
      self.currentLifeEvent = events.first(where: { $0.type == .fertility }) ?? events.first!

      self.currentUser = User(id: UUID(), name: "User", role: .husband)
      self.items = MockData.items  // Prefill with MockData for demo
      self.comparisons = [MockData.comparison]
      self.learningContents = MockData.learningContents

      self.husbandWord = "今日もよろしくね！"
      self.wifeWord = "週末はゆっくり休もう☕️"

      self.isLoggedIn = false
      self.partnerLinked = false

    }
  }

  func login(email: String) -> Bool {
    switch email.lowercased() {
    case "husband@demo.com":
      self.currentUser = MockData.userHusband
      self.isLoggedIn = true
      self.partnerLinked = true
      return true
    case "wife@demo.com":
      self.currentUser = MockData.userWife
      self.isLoggedIn = true
      self.partnerLinked = true
      return true
    default:
      return false
    }
  }

  func demoLogin(as role: UserRole) {
    if role == .husband {
      self.currentUser = MockData.userHusband
    } else {
      self.currentUser = MockData.userWife
    }
    self.isLoggedIn = true
    self.partnerLinked = true
  }

  func getPartner() -> User {
    if currentUser.role == .husband {
      return MockData.userWife
    } else {
      return MockData.userHusband
    }
  }

  func switchLifeEvent(to event: LifeEvent) {

    self.currentLifeEvent = event
  }

  func addItem(_ item: Item) {
    items.append(item)
  }

  func updateItem(_ updatedItem: Item) {
    if let idx = items.firstIndex(where: { $0.id == updatedItem.id }) {
      items[idx] = updatedItem
    }
  }

  func updateComparison(_ updatedComp: ComparisonMatrix) {
    if let idx = comparisons.firstIndex(where: { $0.id == updatedComp.id }) {
      comparisons[idx] = updatedComp
    }
  }

  func deleteItem(_ item: Item) {
    items.removeAll { $0.id == item.id }
  }

  // MARK: - Dummy Sync Actions
  func deleteItem(_ id: UUID) {
    items.removeAll { $0.id == id }
  }
}

// MARK: - AI Helpers (Refactored from AIService)
extension AppState {
  func suggestTitle(for lifeEvent: LifeEventType) -> [String] {
    switch lifeEvent {
    case .fertility:
      return ["クリニック比較", "サプリメント比較", "検査キット比較"]
    case .housing:
      return ["マンション vs 戸建て", "住宅展示場比較", "住宅ローン比較"]
    case .preWedding:
      return ["式場比較", "指輪ブランド比較", "ドレスショップ比較"]
    default:
      return ["\(lifeEvent.rawValue)検討", "オプション比較"]
    }
  }

  func suggestCriteria(for title: String) -> [String] {
    if title.contains("クリニック") {
      return ["通いやすさ", "費用", "実績・口コミ", "予約の取りやすさ", "先生の相性", "待ち時間", "設備"]
    } else if title.contains("式場") {
      return ["料理", "アクセス", "雰囲気", "見積り金額", "持ち込み自由度", "プランナー品質"]
    } else if title.contains("マンション") || title.contains("戸建て") {
      return ["立地", "価格", "間取り", "周辺環境", "資産価値", "日当たり"]
    }
    return ["コスト", "品質", "使いやすさ", "デザイン", "納期", "サポート"]
  }

  func extractInfo(from url: URL) async throws -> (name: String, memo: String) {
    let apiKey = Config.aiApiKey
    if apiKey.isEmpty {
      let host = url.host ?? url.absoluteString.replacingOccurrences(of: "https://", with: "")
      return (String(host.prefix(20)), "APIキーが設定されていないため、自動要約できませんでした。")
    }

    let apiUrl = URL(
      string:
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=\(apiKey)"
    )!
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let prompt =
      "以下のURLの内容を推測または可能であれば取得し、サービス名・施設名・商品名などの「短い名前(name, 15文字以内)」と「特徴を端的に表すメモ(memo, 40文字以内)」を出力してください: \(url.absoluteString)\n必ず {\"name\": \"...\", \"memo\": \"...\"} のJSONフォーマットのみを返してください。マークダウンブロックは不要。"

    let body: [String: Any] = [
      "contents": [
        ["parts": [["text": prompt]]]
      ],
      "generationConfig": ["response_mime_type": "application/json"],
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let candidates = json["candidates"] as? [[String: Any]],
          let first = candidates.first,
          let content = first["content"] as? [String: Any],
          let parts = content["parts"] as? [[String: Any]],
          let text = parts.first?["text"] as? String
        {
          // JSONのコードブロック記法 (```json ... ```) が含まれている場合の処理
          let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

          if let textData = cleanedText.data(using: .utf8),
            let resultMap = try? JSONSerialization.jsonObject(with: textData) as? [String: String]
          {
            let name = resultMap["name"] ?? url.host ?? "抽出成功"
            let memo = resultMap["memo"] ?? "詳細を取得しました"
            return (name, memo)
          }
        }
      }
    } catch {
      print("API Error: \(error)")
    }

    let host = url.host ?? url.absoluteString.replacingOccurrences(of: "https://", with: "")
    return (String(host.prefix(20)), "AIの抽出に失敗しました。")
  }

  // URLから学習コンテンツを生成する
  func generateLearningContent(from url: URL) async throws -> LearningContent? {
    let apiKey = Config.aiApiKey
    if apiKey.isEmpty {
      throw NSError(
        domain: "AppError", code: 1,
        userInfo: [NSLocalizedDescriptionKey: "AI APIキーが設定されていません。環境変数 AI_API_KEY を設定してください。"])
    }

    let apiUrl = URL(
      string:
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=\(apiKey)"
    )!
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let prompt = """
      以下のURLの内容から、ユーザー（妊活や育児、ライフイベントを準備中のカップル）にとって有益な学習コンテンツを生成してください。
      URL: \(url.absoluteString)

      以下のJSONフォーマット(厳格なJSON形式)でのみ出力し、マークダウンブロック(```jsonなど)は含めないでください。
      {
        "title": "コンテンツの短いタイトル (20文字以内)",
        "description": "内容の簡単な要約 (50文字程度)",
        "body": "URLの内容に基づく見出し付きの詳細な学習テキスト。改行には \\n を使用してください。",
        "quizzes": [
          {
            "question": "4択クイズの問題文1",
            "options": ["選択肢A", "選択肢B", "選択肢C", "選択肢D"],
            "answerIndex": 0,
            "explanation": "正解の解説文"
          }
        ],
        "recommendedToDos": [
          {
            "title": "推奨する具体的なアクション1 (例: クリニックを調べる, 予算を決める)",
            "description": "そのアクションの目的"
          }
        ]
      }
      必ずquizzesは3問、recommendedToDosは2〜3個作成してください。
      """

    let body: [String: Any] = [
      "contents": [
        ["parts": [["text": prompt]]]
      ],
      "generationConfig": ["response_mime_type": "application/json"],
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      var errorMsg = "APIサーバーエラー"
      if let httpResponse = response as? HTTPURLResponse {
        errorMsg += " (ステータス: \(httpResponse.statusCode))"
        if let jsonMessage = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let errorObj = jsonMessage["error"] as? [String: Any],
          let detail = errorObj["message"] as? String
        {
          errorMsg += "\\n詳細: \(detail)"
        }
      }
      throw NSError(
        domain: "AppError", code: 2, userInfo: [NSLocalizedDescriptionKey: errorMsg])
    }

    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
      let candidates = json["candidates"] as? [[String: Any]],
      let first = candidates.first,
      let content = first["content"] as? [String: Any],
      let parts = content["parts"] as? [[String: Any]],
      let text = parts.first?["text"] as? String
    {
      let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: "```json", with: "")
        .replacingOccurrences(of: "```", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)

      if let textData = cleanedText.data(using: .utf8),
        let resultMap = try? JSONSerialization.jsonObject(with: textData) as? [String: Any]
      {
        guard let title = resultMap["title"] as? String,
          let description = resultMap["description"] as? String,
          let bodyText = resultMap["body"] as? String,
          let quizzesRaw = resultMap["quizzes"] as? [[String: Any]],
          let todosRaw = resultMap["recommendedToDos"] as? [[String: Any]]
        else {
          throw NSError(
            domain: "AppError", code: 3, userInfo: [NSLocalizedDescriptionKey: "AIの出力フォーマットが不正です。"])
        }

        var parsedQuizzes: [QuizQuestion] = []
        for q in quizzesRaw {
          if let question = q["question"] as? String,
            let options = q["options"] as? [String],
            let answerIndex = q["answerIndex"] as? Int,
            let explanation = q["explanation"] as? String
          {
            parsedQuizzes.append(
              QuizQuestion(
                id: UUID(), question: question, options: options, answerIndex: answerIndex,
                explanation: explanation))
          }
        }

        var parsedToDos: [ActionableToDo] = []
        for t in todosRaw {
          if let tTitle = t["title"] as? String,
            let tDesc = t["description"] as? String
          {
            parsedToDos.append(ActionableToDo(id: UUID(), title: tTitle, description: tDesc))
          }
        }

        let newContent = LearningContent(
          id: UUID(),
          title: title,
          description: description,
          body: bodyText,
          quizzes: parsedQuizzes,
          recommendedToDos: parsedToDos,
          lifeEventId: self.currentLifeEvent.id,
          sourceUrl: url.absoluteString,
          completedBy: [],
          updatedAt: Date()
        )
        return newContent
      }
    }

    throw NSError(
      domain: "AppError", code: 4, userInfo: [NSLocalizedDescriptionKey: "レスポンスのパースに失敗しました。"])
  }

  // --- Phase 12: AI Grounding for Comparison ---

  func evaluateComparisonMatrix(_ matrix: ComparisonMatrix) async {
    let unscoredCells = matrix.candidates.flatMap { candidate in
      matrix.criteria.filter { criteria in
        !matrix.cellValues.contains {
          $0.candidateId == candidate.id && $0.criteriaId == criteria.id
        }
      }.map { (candidate, $0) }
    }

    guard !unscoredCells.isEmpty else { return }

    let apiKey = Config.aiApiKey
    if apiKey.isEmpty { return }

    let apiUrl = URL(
      string:
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=\(apiKey)"
    )!

    // Construct prompt
    let candidateNames = matrix.candidates.map { $0.name }.joined(separator: ", ")
    let criteriaLabels = matrix.criteria.map { $0.label }.joined(separator: ", ")

    let prompt = """
      あなたは比較調査の専門家です。以下の比較表のタイトル、候補、比較軸に基づき、各候補の評価を1〜5点の整数で行ってください。
      WEB上の一般的な情報に基づき、客観的に評価してください。

      タイトル: \(matrix.title)
      候補: \(candidateNames)
      比較軸: \(criteriaLabels)

      出力は以下のJSON形式の配列のみとしてください。マークダウン等は含めないでください。
      [
        { "candidateName": "候補名", "criteriaLabel": "比較軸名", "score": 4 }
      ]
      """

    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let bodyData: [String: Any] = [
      "contents": [["parts": [["text": prompt]]]],
      "generationConfig": ["response_mime_type": "application/json"],
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData)

    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let candidates = json["candidates"] as? [[String: Any]],
        let content = candidates.first?["content"] as? [String: Any],
        let parts = content["parts"] as? [[String: Any]],
        let resultText = parts.first?["text"] as? String,
        let resultData = resultText.data(using: .utf8),
        let scores = try? JSONSerialization.jsonObject(with: resultData) as? [[String: Any]]
      {

        await MainActor.run {
          var updatedMatrix = matrix
          for scoreObj in scores {
            if let cName = scoreObj["candidateName"] as? String,
              let crLabel = scoreObj["criteriaLabel"] as? String,
              let score = scoreObj["score"] as? Int,
              let candidateId = matrix.candidates.first(where: { $0.name == cName })?.id,
              let criteriaId = matrix.criteria.first(where: { $0.label == crLabel })?.id
            {

              let newCell = ComparisonCell(
                candidateId: candidateId, criteriaId: criteriaId, score: score, memo: "AIによる自動評価")
              // Add or Refresh
              if let idx = updatedMatrix.cellValues.firstIndex(where: {
                $0.candidateId == candidateId && $0.criteriaId == criteriaId
              }) {
                updatedMatrix.cellValues[idx] = newCell
              } else {
                updatedMatrix.cellValues.append(newCell)
              }
            }
          }
          self.updateComparison(updatedMatrix)
        }
      }
    } catch {
      print("AI Scoring Error: \(error)")
    }
  }
}
