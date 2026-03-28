import SwiftUI

struct LearningListView: View {
    @EnvironmentObject var appState: AppState
    
    // Stub data for Learning topics
    struct LearningTopic: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let image: String // System Image Name
    }
    
    let topics = [
        LearningTopic(title: "全体の流れを知る", subtitle: "まずはここから", image: "map.fill"),
        LearningTopic(title: "予算の立て方", subtitle: "お金の話をしよう", image: "yensign.circle.fill"),
        LearningTopic(title: "スケジュールの決め方", subtitle: "いつ何をやる？", image: "calendar.badge.clock"),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(topics) { topic in
                        HStack {
                            Image(systemName: topic.image)
                                .font(.system(size: 32))
                                .foregroundColor(.appAccent)
                                .frame(width: 50)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(topic.title)
                                    .font(.appHeadline)
                                    .foregroundColor(.appTextPrimary)
                                Text(topic.subtitle)
                                    .font(.appCaption)
                                    .foregroundColor(.appTextSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("学習")
            .background(Color.appBackground)
        }
    }
}
