import SwiftUI

struct ToDoItemForm: View {
    @EnvironmentObject var appState: AppState
    @Binding var isPresented: Bool
    
    // Form State
    @State private var title: String = ""
    @State private var type: ItemType = .todo
    @State private var isAllDay: Bool = true
    @State private var startAt: Date = Date()
    @State private var endAt: Date = Date().addingTimeInterval(3600)
    @State private var owner: ItemOwner = .both
    @State private var description: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("タイトル (例: 保育園見学)", text: $title)
                    Picker("種類", selection: $type) {
                        Text("ToDo").tag(ItemType.todo)
                        Text("イベント").tag(ItemType.event)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("日時")) {
                    Toggle("終日", isOn: $isAllDay)
                    
                    DatePicker("開始", selection: $startAt, displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                    
                    if type == .event {
                        DatePicker("終了", selection: $endAt, displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("担当 (オーナー)")) {
                    Picker("担当", selection: $owner) {
                        ForEach(ItemOwner.allCases, id: \.self) { owner in
                            Text(owner.label).tag(owner)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("メモ")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
            }
            .navigationTitle("新規作成")
            .navigationBarItems(
                leading: Button("キャンセル") { isPresented = false },
                trailing: Button("保存") {
                    saveItem()
                    isPresented = false
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    func saveItem() {
        let newItem = Item(
            id: UUID(),
            lifeEventId: appState.currentLifeEvent.id,
            type: type,
            title: title,
            description: description.isEmpty ? nil : description,
            owner: owner,
            startAt: startAt,
            endAt: type == .event ? endAt : nil,
            isAllDay: isAllDay,
            status: .open,
            source: .manual,
            createdAt: Date(),
            updatedAt: Date()
        )
        appState.addItem(newItem)
    }
}
