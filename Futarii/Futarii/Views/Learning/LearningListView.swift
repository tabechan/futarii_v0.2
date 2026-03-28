import SwiftUI

struct LearningListView: View {
  @EnvironmentObject var appState: AppState
  @State private var showAddSheet = false

  var currentLearning: [LearningContent] {
    appState.learningContents.filter { $0.lifeEventId == appState.currentLifeEvent.id }
  }

  var partnerCompleted: [LearningContent] {
    let partnerId = appState.getPartner().id
    return appState.learningContents.filter { $0.completedBy.contains(partnerId) }
  }

  var body: some View {
    NavigationView {
      ZStack(alignment: .bottomTrailing) {
        ScrollView {
          VStack(spacing: 24) {
            // Partner Activity
            if !partnerCompleted.isEmpty {
              VStack(alignment: .leading, spacing: 12) {
                Text("パートナーの最近の学習")
                  .font(.appSubheadline)
                  .foregroundColor(.appTextPrimary)

                ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 12) {
                    ForEach(partnerCompleted) { content in
                      VStack(alignment: .leading) {
                        Text(content.title)
                          .font(.system(size: 12, weight: .bold))
                          .lineLimit(1)
                        Text("完了済")
                          .font(.system(size: 10))
                          .foregroundColor(.green)
                      }
                      .padding(12)
                      .background(Color.supportTeal.opacity(0.1))
                      .cornerRadius(12)
                      .frame(width: 150)
                    }
                  }
                }
              }
              .padding()
              .background(Color.cardBackground)
              .cornerRadius(16)
            }

            // Main Content
            VStack(alignment: .leading, spacing: 16) {
              Text("学習コンテンツ")
                .font(.appSubheadline)
                .foregroundColor(.appTextPrimary)

              VStack(spacing: 12) {
                ForEach(currentLearning) { content in
                  NavigationLink(destination: LearningDetailView(content: content)) {
                    LearningRow(
                      content: content,
                      isCompleted: content.completedBy.contains(appState.currentUser.id))
                  }
                  .buttonStyle(PlainButtonStyle())
                }
              }
            }
          }
          .padding()
        }

        FloatingActionButton(showModal: $showAddSheet)
          .padding()
      }
      .navigationTitle("学習")
      .background(Color.appBackground)
      .sheet(isPresented: $showAddSheet) {
        LearningContentURLForm(isPresented: $showAddSheet)
      }
    }
  }
}

// MARK: - Add Learning Content via URL Form
struct LearningContentURLForm: View {
  @EnvironmentObject var appState: AppState
  @Binding var isPresented: Bool
  @State private var urlString = ""
  @State private var isGenerating = false
  @State private var errorMessage: String? = nil

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("URLを入力")) {
          TextField("https://...", text: $urlString)
            .keyboardType(.URL)
            .autocapitalization(.none)
            .disabled(isGenerating)
        }

        if let error = errorMessage {
          Section {
            Text(error)
              .foregroundColor(.red)
              .font(.caption)
          }
        }
      }
      .navigationTitle("AIで学習コンテンツ生成")
      .navigationBarItems(
        leading: Button("キャンセル") {
          isPresented = false
        }
        .disabled(isGenerating),
        trailing: Button("生成する") {
          generateFromURL()
        }
        .disabled(urlString.isEmpty || isGenerating || URL(string: urlString) == nil)
      )
      .overlay(
        Group {
          if isGenerating {
            ZStack {
              Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
              VStack {
                ProgressView()
                  .scaleEffect(1.5)
                  .padding()
                Text("AIが学習コンテンツを作成中です...\\n(30〜60秒ほどかかります)")
                  .font(.callout)
                  .multilineTextAlignment(.center)
                  .padding(.top, 8)
              }
              .padding(32)
              .background(Color.cardBackground)
              .cornerRadius(16)
              .shadow(radius: 10)
            }
          }
        }
      )
    }
  }

  private func generateFromURL() {
    guard let url = URL(string: urlString) else { return }
    isGenerating = true
    errorMessage = nil

    Task {
      do {
        if Array(appState.learningContents).filter({ $0.sourceUrl == urlString }).count > 0 {
          throw NSError(
            domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "すでに同じURLのコンテンツが存在します。"])
        }
        if let newContent = try await appState.generateLearningContent(from: url) {
          DispatchQueue.main.async {
            appState.learningContents.append(newContent)
            isGenerating = false
            isPresented = false
          }
        } else {
          throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "生成に失敗しました。"])
        }
      } catch {
        DispatchQueue.main.async {
          errorMessage = error.localizedDescription
          isGenerating = false
        }
      }
    }
  }
}

struct LearningRow: View {
  let content: LearningContent
  let isCompleted: Bool

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(content.title)
          .font(.appHeadline)
          .foregroundColor(.appTextPrimary)
        Text(content.description)
          .font(.appCaption)
          .foregroundColor(.appTextSecondary)
          .lineLimit(2)
          .multilineTextAlignment(.leading)
      }

      Spacer()

      if isCompleted {
        Image(systemName: "checkmark.seal.fill")
          .foregroundColor(.green)
          .font(.title2)
      } else {
        Image(systemName: "circle")
          .foregroundColor(.gray.opacity(0.3))
          .font(.title2)
      }
    }
    .padding()
    .background(Color.cardBackground)
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
  }
}
