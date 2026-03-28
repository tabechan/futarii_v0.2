import SwiftUI

struct ContentView: View {
    @StateObject var appState = AppState(mock: true)
    @State private var selection: Int = 0
    @State private var showLifeEventModal = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                // Home
                HomeView()
                    .tabItem {
                        Label("ホーム", systemImage: "house.fill")
                    }
                    .tag(0)
                
                // ToDo
                ToDoListView()
                    .tabItem {
                        Label("ToDo", systemImage: "checklist")
                    }
                    .tag(1)
                
                // Comparison
                ComparisonListView()
                    .tabItem {
                        Label("候補比較", systemImage: "arrow.left.arrow.right")
                    }
                    .tag(2)
                
                // Learning
                LearningListView()
                    .tabItem {
                        Label("学習", systemImage: "book.fill")
                    }
                    .tag(3)
                
                // Settings
                SettingsView()
                    .tabItem {
                        Label("設定", systemImage: "gearshape.fill")
                    }
                    .tag(4)
            }
            .accentColor(.appTextPrimary)
            
            // FAB Overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton(showModal: $showLifeEventModal)
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                }
            }
        }
        .sheet(isPresented: $showLifeEventModal) {
            LifeEventSelectionView(showModal: $showLifeEventModal)
        }
        .environmentObject(appState)
    }
}


