import Foundation

class AIService {
  static let shared = AIService()

  // In a real app, these would call LLM APIs (OpenAI, Gemini, etc.)
  // using keys from .env

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
    // Simulate AI extraction from URL
    try await Task.sleep(nanoseconds: 1_000_000_000)

    let urlString = url.absoluteString.lowercased()
    if urlString.contains("hotel") || urlString.contains("stay") {
      return ("抽出されたホテル名", "Webサイトから自動抽出されたメモ: 立地良好、朝食付")
    } else if urlString.contains("item") || urlString.contains("shop") {
      return ("抽出された商品名", "Webサイトから自動抽出されたメモ: 高評価、送料無料")
    }
    return ("Webサイトのタイトル", "自動抽出された情報の要約")
  }
}
