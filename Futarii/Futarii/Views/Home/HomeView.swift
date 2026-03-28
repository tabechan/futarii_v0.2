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

          // Word of the Day Section (Chat Bubble Style)
          VStack(alignment: .leading, spacing: 16) {
            Text("今日の一言")
              .font(.appHeadline)
              .foregroundColor(.appTextPrimary)

            VStack(spacing: 20) {
              // Partner Word (Top)
              HStack(alignment: .bottom, spacing: 8) {
                VStack {
                  Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(
                      appState.getPartner().role == .husband ? .supportBlue : .appAccentHighlight)
                  Text(appState.getPartner().role.label)
                    .font(.system(size: 8))
                    .foregroundColor(.appTextSecondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                  Text(
                    appState.partnerWordOfTheDay.isEmpty
                      ? "まだ入力がありません" : appState.partnerWordOfTheDay
                  )
                  .font(.appBody)
                  .padding(12)
                  .background(Color.white)
                  .cornerRadius(12, corners: [.topLeft, .topRight, .bottomRight])
                  .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                Spacer()
              }

              // My Word (Bottom)
              HStack(alignment: .bottom, spacing: 8) {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                  TextField("メッセージを入力...", text: appState.myWordOfTheDay)
                    .font(.appBody)
                    .padding(12)
                    .background(Color.supportCoralLight.opacity(0.5))
                    .cornerRadius(12, corners: [.topLeft, .topRight, .bottomLeft])
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                }

                VStack {
                  Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(
                      appState.currentUser.role == .husband ? .supportBlue : .appAccentHighlight)
                  Text("\(appState.currentUser.role.label) (自分)")
                    .font(.system(size: 8))
                    .foregroundColor(.appTextSecondary)
                }
              }
            }
          }
          .padding(.horizontal)
          .padding(.vertical, 8)

          // Calendar Section
          VStack(alignment: .leading, spacing: 16) {
            Text("カレンダー")
              .font(.appHeadline)
              .foregroundColor(.appTextPrimary)
              .padding(.horizontal)

            CalendarView(
              currentDate: Date(),
              items: appState.currentItems,  // items for current life event
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
              let cal = Calendar.current
              let todayStart = cal.startOfDay(for: Date())
              let future = cal.date(byAdding: .day, value: 7, to: todayStart)!
              return item.startAt >= todayStart && item.startAt <= future
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

          Spacer(minLength: 80)  // Space for FAB
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
