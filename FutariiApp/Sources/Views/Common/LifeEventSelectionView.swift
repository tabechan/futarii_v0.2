import SwiftUI

struct LifeEventSelectionView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(appState.allLifeEvents) { event in
                        LifeEventCard(event: event, isSelected: appState.currentLifeEvent.id == event.id)
                            .onTapGesture {
                                appState.switchLifeEvent(to: event)
                                showModal = false
                            }
                    }
                    
                    // Button to add other fixed events if not present (Not fully implemented in MVP logic yet)
                    // For now, assume all events or subset exist
                }
                .padding()
            }
            .navigationTitle("ライフイベント選択")
            .navigationBarItems(trailing: Button("閉じる") {
                showModal = false
            })
            .background(Color.appBackground)
        }
    }
}

struct LifeEventCard: View {
    let event: LifeEvent
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Circle()
                .fill(event.displayColor)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "star.fill") // Placeholder icon
                        .foregroundColor(.white)
                )
            
            Text(event.type.rawValue)
                .font(.appBody)
                .foregroundColor(.appTextPrimary)
                .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: isSelected ? event.displayColor.opacity(0.5) : Color.black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? event.displayColor : Color.clear, lineWidth: 2)
        )
    }
}
