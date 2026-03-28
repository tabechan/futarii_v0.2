import SwiftUI

// MARK: - Design System Colors
extension Color {
  // Base
  static let appBackground = Color(hex: "FDF8F5")  // Cream / Pale Shell
  static let cardBackground = Color.white

  // Primary
  static let appTextPrimary = Color(hex: "2D3D88")  // Deep Indigo
  static let appTextSecondary = Color(hex: "5D6CA8")  // Lighter Indigo/Slate

  // Accent
  static let appAccent = Color(hex: "E58B74")  // Terra Cotta
  static let appAccentHighlight = Color(hex: "F2A896")

  // Support
  static let supportYellow = Color(hex: "F4D06F")
  static let supportTeal = Color(hex: "88CCCA")
  static let supportBlue = Color(hex: "889FCC")
  static let supportLavender = Color(hex: "AC92EC")

  // Light variations for ToDo backgrounds
  static let supportBlueLight = Color(hex: "E0E7F5")
  static let supportLavenderLight = Color(hex: "F0EBFA")
  static let supportCoralLight = Color(hex: "F9EBE8")
}

// MARK: - Hex Color Helper
extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a: UInt64
    let r: UInt64
    let g: UInt64
    let b: UInt64
    switch hex.count {
    case 3:  // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6:  // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8:  // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }

    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}

// MARK: - Typography
extension Font {
  static let appTitle = Font.system(size: 28, weight: .bold, design: .default)
  static let appHeadline = Font.system(size: 20, weight: .bold, design: .rounded)
  static let appSubheadline = Font.system(size: 17, weight: .semibold, design: .rounded)
  static let appBody = Font.system(size: 16, weight: .regular, design: .default)
  static let appCaption = Font.system(size: 14, weight: .regular, design: .default)

  // Numbers
  static let appNumberLarge = Font.system(size: 32, weight: .light, design: .default)
}

// MARK: - Icons Helper
extension LifeEventType {
  var systemIcon: String {
    switch self {
    case .preWedding: return "heart.fill"
    case .honeymoon: return "airplane"
    case .fertility: return "leaf.fill"
    case .preChildbirth: return "stroller.fill"
    case .parenting: return "figure.and.child.holdinghands"
    case .nurserySearch: return "building.2.fill"
    case .housing: return "house.fill"
    case .education: return "book.closed.fill"
    case .car: return "car.fill"
    }
  }
}

// MARK: - Shared Shared Views ( Nuclear Consolidation )

// Side Drawer Button helper
extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect, byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

struct SideDrawerButton: View {
  @Binding var showModal: Bool

  var body: some View {
    Button(action: { showModal = true }) {
      VStack(spacing: 4) {
        Image(systemName: "arrow.left.arrow.right")
          .font(.system(size: 20, weight: .bold))
        Text("ライフイベント\n切り替え")
          .font(.system(size: 10, weight: .bold))
          .multilineTextAlignment(.center)
          .lineSpacing(-2)
      }
      .foregroundColor(.white)
      .padding(.leading, 12)
      .padding(.trailing, 8)
      .padding(.vertical, 16)
      .background(Color.appAccent)
      .cornerRadius(20, corners: [.topLeft, .bottomLeft])
      .shadow(color: Color.black.opacity(0.15), radius: 8, x: -2, y: 4)
    }
  }
}

struct LoginView: View {
  @EnvironmentObject var appState: AppState
  @State private var email = ""
  @State private var password = ""
  @State private var showError = false

  var body: some View {
    VStack(spacing: 32) {
      VStack(spacing: 16) {
        Image(systemName: "heart.text.square.fill")
          .font(.system(size: 80))
          .foregroundColor(.appAccent)

        Text("Futarii")
          .font(.appTitle)
          .foregroundColor(.appTextPrimary)

        Text("ふたりの、はじめてを支える")
          .font(.appCaption)
          .foregroundColor(.appTextSecondary)
      }
      .padding(.top, 60)

      VStack(spacing: 16) {
        TextField("husband@demo.com または wife@demo.com", text: $email)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.none)

        SecureField("パスワード (任意)", text: $password)
          .textFieldStyle(RoundedBorderTextFieldStyle())

        if showError {
          Text("無効なアカウントです。")
            .foregroundColor(.red)
            .font(.caption)
        }

        Button(action: {
          if !appState.login(email: email) {
            showError = true
          }
        }) {
          Text("ログイン")
            .font(.appHeadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.appAccent)
            .cornerRadius(12)
        }

        HStack(spacing: 20) {
          Button(action: { email = "husband@demo.com" }) {
            VStack {
              Image(systemName: "person.fill")
              Text("夫でデモ")
            }
            .font(.caption.bold())
            .foregroundColor(.appTextPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.supportBlue.opacity(0.1))
            .cornerRadius(12)
          }

          Button(action: { email = "wife@demo.com" }) {
            VStack {
              Image(systemName: "person.fill")
              Text("妻でデモ")
            }
            .font(.caption.bold())
            .foregroundColor(.appTextPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.supportLavender.opacity(0.1))
            .cornerRadius(12)
          }
        }
        .padding(.top, 8)

        Button(action: { appState.isLoggedIn = true }) {
          Text("新規登録")
            .font(.appSubheadline)
            .foregroundColor(.appAccent)
        }
      }
      .padding(.horizontal, 40)

      Spacer()
    }
    .background(Color.appBackground)
  }
}

struct ToDoDetailView: View {
  @EnvironmentObject var appState: AppState
  @Environment(\.dismiss) var dismiss
  @State var item: Item
  @State private var showEditSheet = false

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        // Header
        HStack {
          VStack(alignment: .leading, spacing: 8) {
            Text(item.type == .event ? "イベント" : "ToDo")
              .font(.appCaption)
              .foregroundColor(.appAccent)
              .padding(.horizontal, 10)
              .padding(.vertical, 4)
              .background(Color.appAccent.opacity(0.1))
              .cornerRadius(8)

            Text(item.title)
              .font(.appTitle)
              .foregroundColor(.appTextPrimary)
          }
          Spacer()

          Button(action: {
            item.status = (item.status == .done ? .open : .done)
            appState.updateItem(item)
          }) {
            Image(systemName: item.status == .done ? "checkmark.circle.fill" : "circle")
              .font(.system(size: 32))
              .foregroundColor(item.status == .done ? .green : .gray)
          }
        }

        // Info Cards
        VStack(spacing: 16) {
          InfoRow(icon: "person.fill", label: "担当", value: item.owner.label)
          InfoRow(icon: "calendar", label: "日付", value: formatDate(item.startAt))
          if let desc = item.description, !desc.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
              HStack {
                Image(systemName: "text.alignleft")
                Text("メモ")
              }
              .font(.appSubheadline)
              .foregroundColor(.appTextSecondary)

              Text(desc)
                .font(.appBody)
                .foregroundColor(.appTextPrimary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appBackground)
                .cornerRadius(12)
            }
          }
        }

        Spacer()
      }
      .padding()
    }
    .navigationBarItems(
      trailing: Button("編集") {
        showEditSheet = true
      }
    )
    .sheet(isPresented: $showEditSheet) {
      ToDoItemForm(isPresented: $showEditSheet, item: item)
    }
    .background(Color.cardBackground)
  }

  private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年 M月 d日 (E)"
    formatter.locale = Locale(identifier: "ja_JP")
    return formatter.string(from: date)
  }
}

struct InfoRow: View {
  let icon: String
  let label: String
  let value: String

  var body: some View {
    HStack {
      Label(label, systemImage: icon)
        .font(.appSubheadline)
        .foregroundColor(.appTextSecondary)
      Spacer()
      Text(value)
        .font(.appBody)
        .foregroundColor(.appTextPrimary)
    }
    .padding()
    .background(Color.appBackground)
    .cornerRadius(12)
  }
}

struct ToDoItemForm: View {
  @EnvironmentObject var appState: AppState
  @Binding var isPresented: Bool
  var item: Item? = nil

  @State private var title: String
  @State private var type: ItemType
  @State private var isAllDay: Bool
  @State private var startAt: Date
  @State private var endAt: Date
  @State private var recurrenceRule: String
  @State private var owner: ItemOwner
  @State private var description: String

  init(isPresented: Binding<Bool>, item: Item? = nil) {
    self._isPresented = isPresented
    self.item = item

    _title = State(initialValue: item?.title ?? "")
    _type = State(initialValue: item?.type ?? .todo)
    _isAllDay = State(initialValue: item?.isAllDay ?? true)
    _startAt = State(initialValue: item?.startAt ?? Date())
    _endAt = State(initialValue: item?.endAt ?? Date().addingTimeInterval(3600))
    _recurrenceRule = State(initialValue: item?.recurrenceRule ?? "なし")
    _owner = State(initialValue: item?.owner ?? .both)
    _description = State(initialValue: item?.description ?? "")
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("基本情報")) {
          TextField("タイトル (例: 保育園見学)", text: $title)
          Picker("種類", selection: $type) {
            Text("ToDo").tag(ItemType.todo)
            Text("イベント").tag(ItemType.event)
          }
          .pickerStyle(SegmentedPickerStyle())
        }

        Section(header: Text("日時")) {
          Toggle("終日", isOn: $isAllDay)

          DatePicker(
            "開始", selection: $startAt,
            displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])

          if type == .event {
            DatePicker(
              "終了", selection: $endAt,
              displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
          }

          Picker("繰り返し", selection: $recurrenceRule) {
            Text("なし").tag("なし")
            Text("毎日").tag("毎日")
            Text("毎週").tag("毎週")
            Text("毎月").tag("毎月")
          }
        }

        Section(header: Text("担当 (オーナー)")) {
          Picker("担当", selection: $owner) {
            ForEach(ItemOwner.allCases, id: \.self) { owner in
              Text(owner.label).tag(owner)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }

        Section(header: Text("メモ")) {
          TextEditor(text: $description)
            .frame(height: 100)
        }
      }
      .navigationTitle(item == nil ? "新規作成" : "編集")
      .navigationBarItems(
        leading: Button("キャンセル") { isPresented = false },
        trailing: Button("保存") {
          saveItem()
          isPresented = false
        }
        .disabled(title.isEmpty)
      )
    }
  }

  func saveItem() {
    let finalRecurrence = recurrenceRule == "なし" ? nil : recurrenceRule
    if let existingItem = item {
      var updated = existingItem
      updated.title = title
      updated.type = type
      updated.isAllDay = isAllDay
      updated.startAt = startAt
      updated.endAt = type == .event ? endAt : nil
      updated.recurrenceRule = finalRecurrence
      updated.owner = owner
      updated.description = description.isEmpty ? nil : description
      updated.updatedAt = Date()
      appState.updateItem(updated)
    } else {
      let newItem = Item(
        id: UUID(),
        lifeEventId: appState.currentLifeEvent.id,
        type: type,
        title: title,
        description: description.isEmpty ? nil : description,
        owner: owner,
        startAt: startAt,
        endAt: type == .event ? endAt : nil,
        isAllDay: isAllDay,
        recurrenceRule: finalRecurrence,
        status: .open,
        source: .manual,
        createdAt: Date(),
        updatedAt: Date()
      )
      appState.addItem(newItem)
    }
  }
}

struct ComparisonFormConfig: Identifiable {
  let id = UUID()
  let initialStep: Int
  let isSingleStepMode: Bool
}

struct ComparisonDetailView: View {
  @EnvironmentObject var appState: AppState
  let comparisonId: UUID
  @State private var formConfig: ComparisonFormConfig? = nil

  init(comparisonId: UUID) {
    self.comparisonId = comparisonId
  }

  let cellWidth: CGFloat = 140
  let cellHeight: CGFloat = 60
  let headerHeight: CGFloat = 80
  let labelWidth: CGFloat = 100

  var body: some View {
    let comparison =
      appState.comparisons.first { $0.id == comparisonId }
      ?? ComparisonMatrix(
        id: comparisonId, lifeEventId: UUID().uuidString, title: "削除済み", createdAt: Date(),
        candidates: [],
        criteria: [], cellValues: [])

    return VStack(spacing: 0) {
      HStack(spacing: 0) {
        VStack(spacing: 0) {
          Rectangle()
            .fill(Color.appBackground)
            .frame(width: labelWidth, height: headerHeight)
            .border(Color.gray.opacity(0.1))

          ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
              ForEach(comparison.criteria) { (criteria: ComparisonCriteria) in
                ZStack(alignment: .topTrailing) {
                  Text(criteria.label)
                    .font(.appBody)
                    .foregroundColor(.appTextPrimary)
                    .frame(width: labelWidth, height: cellHeight, alignment: .leading)
                    .padding(.leading, 8)
                    .background(Color.cardBackground)
                    .border(Color.gray.opacity(0.1), width: 0.5)

                  Button(action: { deleteCriteria(criteria, in: comparison) }) {
                    Image(systemName: "xmark.circle.fill")
                      .foregroundColor(.gray.opacity(0.6))
                      .font(.system(size: 12))
                      .padding(4)
                  }
                }
              }
              // Plus Button for Criteria
              Button(action: {
                formConfig = ComparisonFormConfig(initialStep: 3, isSingleStepMode: true)
              }) {
                Image(systemName: "plus")
                  .frame(width: labelWidth, height: cellHeight)
                  .background(Color.appBackground)
                  .foregroundColor(.appAccent)
                  .border(Color.gray.opacity(0.1), width: 0.5)
              }
            }
          }
        }
        .zIndex(1)
        // Removed shadow from criteria header per user request

        ScrollView(.horizontal, showsIndicators: true) {
          VStack(spacing: 0) {
            HStack(spacing: 0) {
              ForEach(comparison.candidates) { (candidate: ComparisonCandidate) in
                ZStack(alignment: .topTrailing) {
                  VStack {
                    Text(candidate.name)
                      .font(.appHeadline)
                      .foregroundColor(.appTextPrimary)
                    if let memo = candidate.memo {
                      Text(memo)
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                  }
                  .frame(width: cellWidth, height: headerHeight)
                  .background(Color.cardBackground)
                  .border(Color.gray.opacity(0.1), width: 0.5)

                  Button(action: { deleteCandidate(candidate, in: comparison) }) {
                    Image(systemName: "xmark.circle.fill")
                      .foregroundColor(.gray.opacity(0.6))
                      .font(.system(size: 14))
                      .padding(6)
                  }
                }
              }
              // Plus Button for Candidates
              Button(action: {
                formConfig = ComparisonFormConfig(initialStep: 2, isSingleStepMode: true)
              }) {
                Image(systemName: "plus")
                  .frame(width: 60, height: headerHeight)
                  .background(Color.appBackground)
                  .foregroundColor(.appAccent)
                  .border(Color.gray.opacity(0.1), width: 0.5)
              }
            }

            ScrollView(.vertical, showsIndicators: false) {
              VStack(spacing: 0) {
                ForEach(comparison.criteria) { (criteria: ComparisonCriteria) in
                  HStack(spacing: 0) {
                    ForEach(comparison.candidates) { (candidate: ComparisonCandidate) in
                      CellView(
                        comparisonId: comparison.id,
                        candidateId: candidate.id,
                        criteriaId: criteria.id,
                        width: cellWidth,
                        height: cellHeight
                      )
                    }
                    // Spacer for the candidate plus button area
                    Color.clear.frame(width: 60, height: cellHeight)
                  }
                }

                // Empty row for the criteria plus button area
                HStack(spacing: 0) {
                  ForEach(comparison.candidates) { _ in
                    Color.clear.frame(width: cellWidth, height: cellHeight)
                  }
                  Color.clear.frame(width: 60, height: cellHeight)
                }
              }
            }
          }
        }
      }
    }
    .navigationTitle(comparison.title)
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(
      trailing: Button("編集") {
        formConfig = ComparisonFormConfig(initialStep: 1, isSingleStepMode: false)
      }
    )
    .sheet(item: $formConfig) { config in
      ComparisonForm(
        isPresented: Binding(
          get: { formConfig != nil },
          set: { if !$0 { formConfig = nil } }
        ),
        matrix: comparison,
        initialStep: config.initialStep,
        isSingleStepMode: config.isSingleStepMode
      )
    }
    .background(Color.appBackground)
  }

  private func deleteCandidate(_ candidate: ComparisonCandidate, in comparison: ComparisonMatrix) {
    var updated = comparison
    updated.candidates.removeAll { $0.id == candidate.id }
    updated.cellValues.removeAll { $0.candidateId == candidate.id }
    appState.updateComparison(updated)
  }

  private func deleteCriteria(_ criteria: ComparisonCriteria, in comparison: ComparisonMatrix) {
    var updated = comparison
    updated.criteria.removeAll { $0.id == criteria.id }
    updated.cellValues.removeAll { $0.criteriaId == criteria.id }
    appState.updateComparison(updated)
  }
}

struct CellView: View {
  @EnvironmentObject var appState: AppState
  let comparisonId: UUID
  let candidateId: UUID
  let criteriaId: UUID
  let width: CGFloat
  let height: CGFloat

  var body: some View {
    let comparison = appState.comparisons.first { $0.id == comparisonId }
    let currentScore =
      comparison?.cellValues.first {
        $0.candidateId == candidateId && $0.criteriaId == criteriaId
      }?.score ?? 0

    return HStack(spacing: 2) {
      ForEach(1..<6, id: \.self) { index in
        Image(systemName: index <= currentScore ? "star.fill" : "star")
          .font(.system(size: 14))
          .foregroundColor(index <= currentScore ? .supportYellow : .gray.opacity(0.3))
          .onTapGesture {
            updateScore(index, comparison: comparison)
          }
      }
    }
    .frame(width: width, height: height)
    .background(Color.white)
    .border(Color.gray.opacity(0.1), width: 0.5)
  }

  private func updateScore(_ newScore: Int, comparison: ComparisonMatrix?) {
    guard let comp = comparison else { return }
    var updatedComparison = comp
    let newValue = ComparisonCell(
      candidateId: candidateId, criteriaId: criteriaId, score: newScore, memo: nil)

    if let existingIndex = updatedComparison.cellValues.firstIndex(where: {
      $0.candidateId == candidateId && $0.criteriaId == criteriaId
    }) {
      updatedComparison.cellValues[existingIndex] = newValue
    } else {
      updatedComparison.cellValues.append(newValue)
    }
    appState.updateComparison(updatedComparison)
  }
}

struct ComparisonForm: View {
  @EnvironmentObject var appState: AppState
  @Binding var isPresented: Bool
  var matrix: ComparisonMatrix? = nil

  @State private var title: String
  @State private var candidates: [ComparisonCandidate]
  @State private var criteria: [ComparisonCriteria]
  @State private var isSingleStepMode: Bool

  @State private var newCandidateName: String = ""
  @State private var newCriteriaLabel: String = ""
  @State private var newCandidateURL: String = ""
  @State private var isExtracting = false

  @State private var suggestedTitles: [String] = []
  @State private var suggestedCriteria: [String] = []

  @State private var currentStep: Int

  init(
    isPresented: Binding<Bool>, matrix: ComparisonMatrix? = nil, initialStep: Int = 1,
    isSingleStepMode: Bool = false
  ) {
    self._isPresented = isPresented
    self.matrix = matrix

    _title = State(initialValue: matrix?.title ?? "")
    _candidates = State(initialValue: matrix?.candidates ?? [])
    _criteria = State(initialValue: matrix?.criteria ?? [])
    _currentStep = State(initialValue: initialStep)
    _isSingleStepMode = State(initialValue: isSingleStepMode)
  }

  var body: some View {
    NavigationView {
      Form {
        if currentStep == 1 {
          Section(header: Text("ステップ1: 基本情報")) {
            VStack(alignment: .leading) {
              TextField("比較タイトル (例: クリニック比較)", text: $title)
                .onChange(of: title) { _ in updateSuggestions() }

              if !suggestedTitles.isEmpty && title.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack {
                    ForEach(suggestedTitles, id: \.self) { sug in
                      Button(action: { title = sug }) {
                        Text(sug)
                          .font(.caption)
                          .padding(6)
                          .background(Color.appAccent.opacity(0.1))
                          .cornerRadius(8)
                      }
                    }
                  }
                  .padding(.vertical, 4)
                }
              }
            }
          }
        }

        if currentStep == 2 {
          Section(header: Text("ステップ2: 比較候補")) {
            ForEach(candidates) { candidate in
              HStack {
                Text(candidate.name)
                Spacer()
                Button(action: { candidates.removeAll { $0.id == candidate.id } }) {
                  Image(systemName: "minus.circle.fill").foregroundColor(.red)
                }
              }
            }

            VStack(spacing: 12) {
              HStack {
                TextField("新しい候補名", text: $newCandidateName)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addCandidateManual) {
                  Text("追加")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.appAccent)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(newCandidateName.isEmpty)
              }

              Divider().padding(.vertical, 4)

              HStack {
                TextField("URLからAI抽出", text: $newCandidateURL)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: extractFromURL) {
                  if isExtracting {
                    ProgressView()
                  } else {
                    Text("AI抽出")
                      .padding(.horizontal)
                      .padding(.vertical, 8)
                      .background(Color.supportTeal)
                      .foregroundColor(.white)
                      .cornerRadius(8)
                  }
                }
                .disabled(newCandidateURL.isEmpty || isExtracting)
              }
            }
            .padding(.vertical, 8)
          }
        }

        if currentStep == 3 {
          Section(header: Text("ステップ3: 比較軸")) {
            ForEach(criteria) { cr in
              HStack {
                Text(cr.label)
                Spacer()
                Button(action: { criteria.removeAll { $0.id == cr.id } }) {
                  Image(systemName: "minus.circle.fill").foregroundColor(.red)
                }
              }
            }

            if !suggestedCriteria.isEmpty {
              Text("AIおすすめの比較軸")
                .font(.caption)
                .foregroundColor(.appTextSecondary)

              FlowLayout(items: suggestedCriteria) { sug in
                Button(action: { addCriteria(sug) }) {
                  Text("+ \(sug)")
                    .font(.appBody)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.supportTeal.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
              }
            }

            HStack {
              TextField("新しい比較軸 (その他)", text: $newCriteriaLabel)
              Button(action: {
                addCriteria(newCriteriaLabel)
                newCriteriaLabel = ""
              }) {
                Image(systemName: "plus.circle.fill")
              }
              .disabled(newCriteriaLabel.isEmpty)
            }
          }
        }
      }  // Closes Form
      .navigationTitle(
        isSingleStepMode
          ? (currentStep == 2 ? "比較候補を追加" : "比較軸を追加")
          : (matrix == nil ? "新規比較作成 (\(currentStep)/3)" : "比較編集 (\(currentStep)/3)")
      )
      .navigationBarItems(
        leading: Group {
          if isSingleStepMode {
            Button("キャンセル") { isPresented = false }
          } else if currentStep > 1 {
            Button("戻る") { currentStep -= 1 }
          } else {
            Button("キャンセル") { isPresented = false }
          }
        },
        trailing: Group {
          if isSingleStepMode {
            Button("完了") {
              saveMatrix()
              isPresented = false
            }
            .disabled(currentStep == 1 && title.isEmpty)
          } else if currentStep < 3 {
            Button("次へ") { currentStep += 1 }
              .disabled(currentStep == 1 && title.isEmpty)
          } else {
            Button("保存") {
              saveMatrix()
              isPresented = false
            }
            .disabled(title.isEmpty || candidates.isEmpty)
          }
        }
      )
      .onAppear {
        suggestedTitles = appState.suggestTitle(for: appState.currentLifeEvent.type)
        updateSuggestions()
      }
    }
  }

  private func updateSuggestions() {
    suggestedCriteria = appState.suggestCriteria(for: title)
      .filter { sug in !criteria.contains(where: { $0.label == sug }) }
  }

  private func addCandidateManual() {
    guard !newCandidateName.isEmpty else { return }
    let newC = ComparisonCandidate(id: UUID(), name: newCandidateName, memo: nil)
    candidates.append(newC)
    newCandidateName = ""
  }

  private func extractFromURL() {
    var urlString = newCandidateURL.trimmingCharacters(in: .whitespacesAndNewlines)
    if !urlString.lowercased().hasPrefix("http") {
      urlString = "https://" + urlString
    }

    guard let url = URL(string: urlString) else { return }
    isExtracting = true
    Task {
      do {
        let info = try await appState.extractInfo(from: url)
        await MainActor.run {
          candidates.append(ComparisonCandidate(id: UUID(), name: info.name, memo: info.memo))
          newCandidateURL = ""
          isExtracting = false
        }
      } catch {
        await MainActor.run { isExtracting = false }
      }
    }
  }

  private func addCriteria(_ label: String) {
    if !criteria.contains(where: { $0.label == label }) {
      let newCr = ComparisonCriteria(id: UUID(), label: label, orderIndex: criteria.count)
      criteria.append(newCr)
    }
    updateSuggestions()
  }

  private func saveMatrix() {
    if var existing = matrix {
      existing.title = title
      existing.candidates = candidates
      existing.criteria = criteria
      appState.updateComparison(existing)
      Task { await appState.evaluateComparisonMatrix(existing) }
    } else {
      let newMatrix = ComparisonMatrix(
        id: UUID(),
        lifeEventId: appState.currentLifeEvent.id,
        title: title,
        createdAt: Date(),
        candidates: candidates,
        criteria: criteria,
        cellValues: []
      )
      appState.comparisons.append(newMatrix)
      Task { await appState.evaluateComparisonMatrix(newMatrix) }
    }
  }
}

@available(iOS 16.0, *)
struct _FlowLayout: Layout {
  var spacing: CGFloat = 8

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let width = proposal.width ?? .infinity
    var currentX: CGFloat = 0
    var currentY: CGFloat = 0
    var lineHeight: CGFloat = 0

    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      if currentX + size.width > width {
        currentX = 0
        currentY += lineHeight + spacing
        lineHeight = 0
      }
      lineHeight = max(lineHeight, size.height)
      currentX += size.width + spacing
    }

    return CGSize(width: width, height: currentY + lineHeight)
  }

  func placeSubviews(
    in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
  ) {
    var currentX: CGFloat = bounds.minX
    var currentY: CGFloat = bounds.minY
    var lineHeight: CGFloat = 0

    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      if currentX + size.width > bounds.maxX {
        currentX = bounds.minX
        currentY += lineHeight + spacing
        lineHeight = 0
      }
      subview.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
      lineHeight = max(lineHeight, size.height)
      currentX += size.width + spacing
    }
  }
}

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
  let items: Data
  let content: (Data.Element) -> Content

  var body: some View {
    if #available(iOS 16.0, *) {
      _FlowLayout(spacing: 8) {
        ForEach(items, id: \.self) { item in
          content(item)
        }
      }
    } else {
      // iOS 15 Fallback (Simplified)
      VStack(alignment: .leading, spacing: 8) {
        ForEach(items, id: \.self) { item in
          content(item)
        }
      }
    }
  }
}

struct LearningDetailView: View {
  @EnvironmentObject var appState: AppState
  @State var content: LearningContent
  @Environment(\.dismiss) var dismiss

  @State private var showQuiz = false
  @State private var showToDos = false

  var isCompleted: Bool {
    content.completedBy.contains(appState.currentUser.id)
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        Text(content.title)
          .font(.appTitle)
          .foregroundColor(.appTextPrimary)

        VStack(alignment: .leading, spacing: 16) {
          Text("詳細レポート")
            .font(.appHeadline)

          Text(content.body)
            .font(.appBody)
            .foregroundColor(.appTextPrimary)
            .lineSpacing(6)
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)

        if let urlStr = content.sourceUrl, let url = URL(string: urlStr) {
          Link(destination: url) {
            HStack {
              Image(systemName: "safari")
              Text("元の記事を読む")
            }
            .font(.appHeadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.supportBlue)
            .cornerRadius(16)
          }
        }

        Spacer()

        Button(action: { showQuiz = true }) {
          HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "questionmark.circle.fill")
            Text(isCompleted ? "完了済み (クイズ再挑戦)" : "理解度確認クイズ")
          }
          .font(.appHeadline)
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .padding()
          .background(isCompleted ? Color.green : Color.appAccent)
          .cornerRadius(16)
        }

        let partnerId = appState.getPartner().id
        let isPartnerCompleted = content.completedBy.contains(partnerId)

        HStack {
          Spacer()
          Image(systemName: isPartnerCompleted ? "checkmark.seal.fill" : "rays")
            .foregroundColor(isPartnerCompleted ? .appAccent : .gray)
          Text("\(appState.getPartner().role.label)の学習状況: \(isPartnerCompleted ? "完了" : "未完了")")
            .font(.appCaption)
            .foregroundColor(.appTextSecondary)
          Spacer()
        }
        .padding(.bottom, 24)
      }
      .padding()
    }
    .background(Color.appBackground)
    .fullScreenCover(isPresented: $showQuiz) {
      QuizView(
        content: content, isPresented: $showQuiz,
        onPass: {
          markAsCompleted()
          showToDos = true
        })
    }
    .sheet(isPresented: $showToDos) {
      ToDoRecommendationView(content: content, isPresented: $showToDos)
    }
  }

  private func markAsCompleted() {
    content.completedBy.insert(appState.currentUser.id)
    if let index = appState.learningContents.firstIndex(where: { $0.id == content.id }) {
      appState.learningContents[index] = content
    }
  }
}

// MARK: - Quiz View
struct QuizView: View {
  let content: LearningContent
  @Binding var isPresented: Bool
  var onPass: () -> Void

  @State private var currentQuestionIndex = 0
  @State private var selectedAnswer: Int?
  @State private var answers: [Int?]
  @State private var showResult = false

  init(content: LearningContent, isPresented: Binding<Bool>, onPass: @escaping () -> Void) {
    self.content = content
    self._isPresented = isPresented
    self.onPass = onPass
    self._answers = State(initialValue: Array(repeating: nil, count: content.quizzes.count))
  }

  var score: Int {
    var s = 0
    for i in 0..<content.quizzes.count {
      if answers[i] == content.quizzes[i].answerIndex { s += 1 }
    }
    return s
  }

  var isPassed: Bool {
    score >= 2
  }

  var body: some View {
    NavigationView {
      VStack {
        if showResult {
          VStack(spacing: 24) {
            Image(systemName: isPassed ? "party.popper.fill" : "exclamationmark.triangle.fill")
              .font(.system(size: 64))
              .foregroundColor(isPassed ? .appAccent : .supportYellow)

            Text(isPassed ? "クリア！" : "残念！")
              .font(.appTitle)

            Text("\(content.quizzes.count)問中 \(score)問 正解しました。")
              .font(.appHeadline)

            Text(isPassed ? "理解度が確認できました。\n学習完了とします。" : "2問以上正解でクリアとなります。\nもう一度復習してみましょう。")
              .multilineTextAlignment(.center)
              .foregroundColor(.appTextSecondary)

            Spacer()

            if isPassed {
              Button(action: {
                isPresented = false
                onPass()
              }) {
                Text("次へ (ToDoを設定する)")
                  .font(.appHeadline)
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(Color.appAccent)
                  .cornerRadius(12)
              }
            } else {
              Button(action: {
                currentQuestionIndex = 0
                answers = Array(repeating: nil, count: content.quizzes.count)
                showResult = false
              }) {
                Text("もう一度クイズを受ける")
                  .font(.appHeadline)
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(Color.appAccent)
                  .cornerRadius(12)
              }

              Button(action: {
                isPresented = false
              }) {
                Text("詳細ページに戻る")
                  .font(.appHeadline)
                  .foregroundColor(.appTextPrimary)
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(Color.gray.opacity(0.1))
                  .cornerRadius(12)
              }
            }
          }
          .padding(32)
        } else {
          let question = content.quizzes[currentQuestionIndex]

          VStack(alignment: .leading, spacing: 24) {
            Text("Q\(currentQuestionIndex + 1) / \(content.quizzes.count)")
              .font(.appCaption)
              .foregroundColor(.appTextSecondary)

            Text(question.question)
              .font(.appHeadline)
              .foregroundColor(.appTextPrimary)

            VStack(spacing: 12) {
              ForEach(0..<question.options.count, id: \.self) { i in
                Button(action: {
                  selectedAnswer = i
                }) {
                  HStack {
                    Image(systemName: selectedAnswer == i ? "largecircle.fill.circle" : "circle")
                      .foregroundColor(selectedAnswer == i ? .appAccent : .gray)
                    Text(question.options[i])
                      .font(.appBody)
                      .foregroundColor(.appTextPrimary)
                      .multilineTextAlignment(.leading)
                    Spacer()
                  }
                  .padding()
                  .background(
                    selectedAnswer == i ? Color.appAccent.opacity(0.1) : Color.cardBackground
                  )
                  .cornerRadius(12)
                  .overlay(
                    RoundedRectangle(cornerRadius: 12)
                      .stroke(
                        selectedAnswer == i ? Color.appAccent : Color.gray.opacity(0.2),
                        lineWidth: 1)
                  )
                }
              }
            }

            Spacer()

            Button(action: {
              answers[currentQuestionIndex] = selectedAnswer
              selectedAnswer = nil

              if currentQuestionIndex < content.quizzes.count - 1 {
                currentQuestionIndex += 1
              } else {
                showResult = true
              }
            }) {
              Text(currentQuestionIndex < content.quizzes.count - 1 ? "次の問題へ" : "結果を見る")
                .font(.appHeadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.appAccent)
                .cornerRadius(12)
            }
            .disabled(selectedAnswer == nil)
          }
          .padding()
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(leading: Button("閉じる") { isPresented = false })
      .background(Color.appBackground)
    }
  }
}

// MARK: - ToDo Recommendation View
struct EditableActionableToDo: Identifiable {
  let id = UUID()
  var title: String
  var description: String
  var owner: ItemOwner = .both
  var startAt: Date = Date()
}

struct ToDoRecommendationView: View {
  @EnvironmentObject var appState: AppState
  let content: LearningContent
  @Binding var isPresented: Bool

  @State private var todos: [EditableActionableToDo]

  init(content: LearningContent, isPresented: Binding<Bool>) {
    self.content = content
    self._isPresented = isPresented

    let mapped = content.recommendedToDos.map {
      EditableActionableToDo(title: $0.title, description: $0.description)
    }
    self._todos = State(initialValue: mapped)
  }

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        VStack(spacing: 8) {
          Text("学んだ内容を踏まえた\nToDoを設定しますか？")
            .font(.appHeadline)
            .multilineTextAlignment(.center)
            .foregroundColor(.appTextPrimary)
            .padding(.top, 16)

          Text("提案されたアクションから今日から取り組めるものを設定しましょう。")
            .font(.appCaption)
            .foregroundColor(.appTextSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        .padding(.bottom, 16)

        List {
          ForEach($todos) { $todo in
            Section {
              TextField("タイトル", text: $todo.title)
                .font(.appSubheadline)

              TextField("メモ (任意)", text: $todo.description)
                .font(.appCaption)
                .foregroundColor(.gray)

              Picker("担当", selection: $todo.owner) {
                ForEach(ItemOwner.allCases, id: \.self) { o in
                  Text(o.label).tag(o)
                }
              }
              .pickerStyle(.segmented)

              DatePicker("日付", selection: $todo.startAt, displayedComponents: .date)
            }
          }
          .onDelete { indexSet in
            todos.remove(atOffsets: indexSet)
          }

          Button(action: {
            todos.append(EditableActionableToDo(title: "", description: ""))
          }) {
            HStack {
              Image(systemName: "plus.circle.fill")
              Text("ToDoを追加する")
            }
            .foregroundColor(.appAccent)
          }
        }
        .listStyle(.insetGrouped)

        Button(action: saveToDos) {
          Text("ToDoを設定する")
            .font(.appHeadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.appAccent)
            .cornerRadius(12)
        }
        .padding()
      }
      .background(Color.appBackground)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(
        leading: Button("スキップ") { isPresented = false }
      )
    }
  }

  private func saveToDos() {
    for t in todos {
      guard !t.title.isEmpty else { continue }
      let newItem = Item(
        id: UUID(),
        lifeEventId: content.lifeEventId,
        type: .todo,
        title: t.title,
        description: t.description.isEmpty ? nil : t.description,
        owner: t.owner,
        startAt: t.startAt,
        endAt: nil,
        isAllDay: true,
        recurrenceRule: nil,
        status: .open,
        source: .autoLearning,
        createdAt: Date(),
        updatedAt: Date()
      )
      appState.addItem(newItem)
    }
    isPresented = false
  }
}
