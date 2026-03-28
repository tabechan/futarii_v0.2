import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var appState: AppState
  @State private var showLinkAlert = false
  @State private var partnerCodeInput = ""

  var body: some View {
    NavigationView {
      List {
        Section(header: Text("プロフィール")) {
          HStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
              .font(.system(size: 60))
              .foregroundColor(.gray)

            VStack(alignment: .leading) {
              Text(appState.currentUser.name)
                .font(.appHeadline)
              Text(appState.currentUser.role.label)
                .font(.appCaption)
                .foregroundColor(.gray)
            }
          }
          .padding(.vertical, 8)
        }

        Section(header: Text("パートナー連携")) {
          if appState.partnerLinked {
            HStack {
              Text("連携ステータス")
              Spacer()
              Text("連携済み")
                .foregroundColor(.green)
            }
          } else {
            VStack(alignment: .leading, spacing: 12) {
              Text("自分の連携コード")
                .font(.caption)
                .foregroundColor(.gray)
              Text(appState.myPartnerCode)
                .font(.appTitle)
                .kerning(4)

              Divider()

              Text("パートナーのコードを入力")
                .font(.caption)
                .foregroundColor(.gray)
              HStack {
                TextField("6桁のコード", text: $partnerCodeInput)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .keyboardType(.numberPad)

                Button("連携") {
                  if partnerCodeInput.count == 6 {
                    appState.partnerLinked = true
                    showLinkAlert = true
                  }
                }
                .disabled(partnerCodeInput.count != 6)
              }
            }
            .padding(.vertical, 8)
          }
        }

        Section(header: Text("AI アシスタント設定")) {
          SecureField(
            "APIキー (OpenAI/Gemini)",
            text: Binding(
              get: { UserDefaults.standard.string(forKey: "AI_API_KEY") ?? "" },
              set: { UserDefaults.standard.set($0, forKey: "AI_API_KEY") }
            )
          )
          .textFieldStyle(RoundedBorderTextFieldStyle())

          Text("キーを入力すると比較画面のAI抽出機能や学習コンテンツの自動生成が有効になります。")
            .font(.caption)
            .foregroundColor(.gray)
        }

        Section(header: Text("アカウント")) {
          Button(action: { appState.isLoggedIn = false }) {
            Text("ログアウト")
              .foregroundColor(.red)
          }
        }

        Section(header: Text("アプリについて")) {
          HStack {
            Text("バージョン")
            Spacer()
            Text("0.2.0")
              .foregroundColor(.gray)
          }
        }
      }
      .navigationTitle("設定")
      .scrollContentBackground(.hidden)
      .background(Color.appBackground)
      .listStyle(InsetGroupedListStyle())
      .alert(isPresented: $showLinkAlert) {
        Alert(
          title: Text("連携完了"), message: Text("パートナーとの連携が完了しました。"),
          dismissButton: .default(Text("OK")))
      }
    }
  }
}
