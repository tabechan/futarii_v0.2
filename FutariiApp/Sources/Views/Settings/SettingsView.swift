import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("アカウント")) {
                    HStack {
                        Text("名前")
                        Spacer()
                        Text(appState.currentUser.name)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("ロール")
                        Spacer()
                        Text(appState.currentUser.role == .husband ? "夫" : "妻")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("アプリ設定")) {
                    NavigationLink("通知設定", destination: Text("Notification Settings"))
                    NavigationLink("テーマカラー", destination: Text("Theme Settings"))
                }
                
                Section(header: Text("データ管理")) {
                    Button("データのエクスポート") {
                        // Action
                    }
                    .foregroundColor(.blue)
                }
                
                Section {
                    Text("Version 0.2.0")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("設定")
            .background(Color.appBackground)
        }
    }
}
