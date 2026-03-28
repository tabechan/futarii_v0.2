import SwiftUI

struct ComparisonListView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCreateSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(appState.currentComparisons) { comparison in
                        NavigationLink(destination: ComparisonDetailView(comparison: comparison)) {
                            ComparisonCard(comparison: comparison)
                        }
                    }
                    
                    // Add Button Card
                    Button(action: { showCreateSheet = true }) {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.appAccent)
                            Text("新規比較")
                                .font(.appBody)
                                .foregroundColor(.appTextPrimary)
                                .padding(.top, 4)
                        }
                        .frame(height: 140)
                        .frame(maxWidth: .infinity)
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(.appTextSecondary.opacity(0.5))
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("候補比較")
            .background(Color.appBackground)
        }
    }
}

struct ComparisonCard: View {
    let comparison: ComparisonMatrix
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(comparison.title)
                .font(.appHeadline)
                .foregroundColor(.appTextPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            HStack {
                Text("\(comparison.candidates.count) 候補")
                Spacer()
                Text("\(comparison.criteria.count) 項目")
            }
            .font(.caption)
            .foregroundColor(.appTextSecondary)
        }
        .padding()
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
