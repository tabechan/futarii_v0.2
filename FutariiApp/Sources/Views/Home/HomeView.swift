import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Area
                    HStack {
                        VStack(alignment: .leading) {
                            Text(appState.currentLifeEvent.type.rawValue)
                                .font(.appTitle)
                                .foregroundColor(.appTextPrimary)
                            Text("現在のライフイベント")
                                .font(.appCaption)
                                .foregroundColor(.appTextSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Calendar Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("カレンダー")
                            .font(.appHeadline)
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal)
                        
                        CalendarView(
                            currentDate: Date(),
                            items: appState.currentItems, // items for current life event
                            accentColor: appState.currentLifeEvent.displayColor
                        )
                        .padding(.horizontal)
                    }
                    
                    // Recent ToDos Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("直近1週間のToDo")
                            .font(.appHeadline)
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal)
                        
                        let recentItems = appState.currentItems.filter { item in
                            guard item.type == .todo && item.status != .done else { return false }
                            // Filter logic: assume simple next 7 days check
                            let now = Date()
                            let future = now.addingTimeInterval(86400 * 7)
                            return item.startAt >= now && item.startAt <= future
                        }.sorted(by: { $0.startAt < $1.startAt })
                        
                        if recentItems.isEmpty {
                             Text("直近のタスクはありません")
                                .font(.appBody)
                                .foregroundColor(.appTextSecondary)
                                .padding()
                        } else {
                            ForEach(recentItems) { item in
                                HomeToDoCard(item: item, accentColor: appState.currentLifeEvent.displayColor)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 80) // Space for FAB
                }
                .padding(.top)
            }
            .background(Color.appBackground)
            .navigationBarHidden(true)
        }
    }
}

struct HomeToDoCard: View {
    let item: Item
    let accentColor: Color
    
    var body: some View {
        HStack(alignment: .top) {
            // Checkbox placeholder
            Circle()
                .stroke(accentColor, lineWidth: 2)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.appBody)
                    .strikethrough(item.status == .done)
                    .foregroundColor(item.status == .done ? .gray : .appTextPrimary)
                
                HStack {
                    Label(formatDate(item.startAt), systemImage: "calendar")
                    Spacer()
                    Text(item.owner.label)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.appTextSecondary.opacity(0.1))
                        .cornerRadius(4)
                }
                .font(.appCaption)
                .foregroundColor(.appTextSecondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M/d (E)"
        return formatter.string(from: date)
    }
}
