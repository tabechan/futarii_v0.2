import SwiftUI

struct LifeEventSelectionView: View {
  @EnvironmentObject var appState: AppState
  @Binding var isPresented: Bool

  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(appState.allLifeEvents) { event in
            LifeEventTile(
              event: event,
              isSelected: event.id == appState.currentLifeEvent.id
            ) {
              appState.switchLifeEvent(to: event)
              isPresented = false
            }
          }
        }
        .padding()
      }
      .navigationTitle("ライフイベント選択")
      .navigationBarItems(trailing: Button("閉じる") { isPresented = false })
      .background(Color.appBackground)
    }
  }
}

struct LifeEventTile: View {
  let event: LifeEvent
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 12) {
        Image(systemName: event.type.systemIcon)
          .font(.system(size: 32))
          .foregroundColor(event.displayColor)

        Text(event.type.rawValue)
          .font(.appSubheadline)
          .foregroundColor(.appTextPrimary)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.cardBackground)
      .cornerRadius(16)
      .shadow(
        color: isSelected ? event.displayColor.opacity(0.5) : Color.black.opacity(0.1),
        radius: isSelected ? 8 : 4, x: 0, y: 2
      )
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(isSelected ? event.displayColor : Color.clear, lineWidth: 2)
      )
    }
  }
}
