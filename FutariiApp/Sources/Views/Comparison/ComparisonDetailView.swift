import SwiftUI

struct ComparisonDetailView: View {
    let comparison: ComparisonMatrix
    @State private var candidates: [ComparisonCandidate]
    
    init(comparison: ComparisonMatrix) {
        self.comparison = comparison
        self._candidates = State(initialValue: comparison.candidates)
    }
    
    // Config
    let cellWidth: CGFloat = 140
    let cellHeight: CGFloat = 60
    let headerHeight: CGFloat = 80
    let labelWidth: CGFloat = 100
    
    var body: some View {
        VStack(spacing: 0) {
            // Matrix
            HStack(spacing: 0) {
                // Fixed Left Column (Criteria Labels)
                VStack(spacing: 0) {
                    // Corner (Empty)
                    Rectangle()
                        .fill(Color.appBackground)
                        .frame(width: labelWidth, height: headerHeight)
                        .border(Color.gray.opacity(0.1))
                    
                    // Criteria Rows
                    ScrollView(.vertical, showsIndicators: false) { // Synced Scroll technically difficult without preferences, simplified here for MVP
                         VStack(spacing: 0) {
                            ForEach(comparison.criteria) { criteria in
                                Text(criteria.label)
                                    .font(.appBody)
                                    .foregroundColor(.appTextPrimary)
                                    .frame(width: labelWidth, height: cellHeight, alignment: .leading)
                                    .padding(.leading, 8)
                                    .background(Color.cardBackground)
                                    .border(Color.gray.opacity(0.1), width: 0.5)
                            }
                        }
                    }
                    .disabled(true) // Disable scroll on label column if not synced
                }
                .zIndex(1)
                .shadow(radius: 2, x: 1, y: 0)
                
                // Scrollable Content
                ScrollView(.horizontal, showsIndicators: true) {
                    VStack(spacing: 0) {
                        // Header Row (Candidates)
                        HStack(spacing: 0) {
                            ForEach(candidates) { candidate in
                                VStack {
                                    Text(candidate.name)
                                        .font(.appHeadline)
                                        .foregroundColor(.appTextPrimary)
                                    if let memo = candidate.memo {
                                        Text(memo)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(width: cellWidth, height: headerHeight)
                                .background(Color.cardBackground)
                                .border(Color.gray.opacity(0.1), width: 0.5)
                            }
                        }
                        
                        // Data Rows
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(comparison.criteria) { criteria in
                                    HStack(spacing: 0) {
                                        ForEach(candidates) { candidate in
                                            let cell = comparison.cellValues.first { $0.candidateId == candidate.id && $0.criteriaId == criteria.id }
                                            CellView(score: cell?.score ?? 0, width: cellWidth, height: cellHeight)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(comparison.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.appBackground)
    }
}

struct CellView: View {
    let score: Int
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= score ? "star.fill" : "star")
                    .font(.system(size: 14))
                    .foregroundColor(index <= score ? .supportYellow : .gray.opacity(0.3))
            }
        }
        .frame(width: width, height: height)
        .background(Color.white)
        .border(Color.gray.opacity(0.1), width: 0.5)
    }
}
