import SwiftUI

struct ToDoListView: View {
    @EnvironmentObject var appState: AppState
    @State private var filterOwner: ItemOwner? = nil // nil = All
    @State private var filterStatus: ItemStatus = .open // Default to Open
    
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // Status Filter
                        Picker("Status", selection: $filterStatus) {
                            Text("未完了").tag(ItemStatus.open)
                            Text("完了").tag(ItemStatus.done)
                            Text("すべて").tag(ItemStatus.archived) // Using archived as 'All' proxy or handle differently
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                        
                        // Owner Filter
                        ForEach(ItemOwner.allCases, id: \.self) { owner in
                            FilterChip(label: owner.label, isSelected: filterOwner == owner) {
                                if filterOwner == owner {
                                    filterOwner = nil
                                } else {
                                    filterOwner = owner
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        let filteredItems = appState.currentItems.filter { item in
                            // Filter by Status (Simple logic)
                            if filterStatus != .archived { // Using archived as "All" for simplest UI mapping in MVP
                                if item.status != filterStatus { return false }
                            }
                            
                            // Filter by Owner
                            if let owner = filterOwner {
                                if item.owner != owner { return false }
                            }
                            
                            return true
                        }.sorted(by: { $0.startAt < $1.startAt })
                        
                        ForEach(filteredItems) { item in
                            ToDoItemRow(item: item)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
            .navigationTitle(appState.currentLifeEvent.type.rawValue)
            .background(Color.appBackground)
            .overlay(
                // Floating Action Button for Adding
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showAddSheet = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.appAccent)
                                .clipShape(Circle())
                                .shadow(radius: 4, y: 4)
                        }
                        .padding()
                    }
                }
            )
            .sheet(isPresented: $showAddSheet) {
                ToDoItemForm(isPresented: $showAddSheet)
            }
            .navigationBarHidden(true) // Hide standard nav bar to use custom header if needed, or keep standard
        }
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.appCaption)
                .foregroundColor(isSelected ? .white : .appTextPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.appTextPrimary : Color.cardBackground)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct ToDoItemRow: View {
    let item: Item
    
    var body: some View {
        HStack {
            Image(systemName: item.status == .done ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.status == .done ? .green : .gray)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.appBody)
                    .strikethrough(item.status == .done)
                    .foregroundColor(item.status == .done ? .gray : .appTextPrimary)
                
                if let desc = item.description, !desc.isEmpty {
                    Text(desc)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                HStack {
                    if item.type == .event {
                        Label("イベント", systemImage: "calendar")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    Text(item.owner.label)
                        .font(.caption2)
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
