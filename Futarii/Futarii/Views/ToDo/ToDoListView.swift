import SwiftUI

struct ToDoListView: View {
  @EnvironmentObject var appState: AppState
  @State private var filterStatus: ItemStatus? = .open
  @State private var filterOwner: ItemOwner? = nil
  @State private var showAddSheet = false

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        // Header / Chart Section
        VStack(alignment: .leading, spacing: 16) {
          Text("ToDo")
            .font(.appTitle)
            .foregroundColor(.appTextPrimary)
            .padding(.top, 20)

          Text("担当比率")
            .font(.appSubheadline)
            .foregroundColor(.appTextPrimary)

          ToDoDistributionBar(items: appState.items)

          Divider()

          Text("今のコンディション")
            .font(.appSubheadline)
            .foregroundColor(.appTextPrimary)

          HStack(spacing: 20) {
            VStack(alignment: .leading) {
              Text("自分")
                .font(.caption)
                .foregroundColor(.appTextSecondary)
              HStack(spacing: 12) {
                StatusEmojiButton(
                  imageName: "condition_03", label: PartnerLoadStatus.struggling.label,
                  isSelected: appState.currentUser.loadStatus == .struggling,
                  action: { appState.currentUser.loadStatus = .struggling })

                StatusEmojiButton(
                  imageName: "condition_02", label: PartnerLoadStatus.goingWell.label,
                  isSelected: appState.currentUser.loadStatus == .goingWell,
                  action: { appState.currentUser.loadStatus = .goingWell })

                StatusEmojiButton(
                  imageName: "condition_01", label: PartnerLoadStatus.available.label,
                  isSelected: appState.currentUser.loadStatus == .available,
                  action: { appState.currentUser.loadStatus = .available })
              }
            }

            VStack(alignment: .leading) {
              Text("パートナー")
                .font(.caption)
                .foregroundColor(.appTextSecondary)

              VStack(spacing: 4) {
                Image(getConditionImageName(for: appState.getPartner().loadStatus))
                  .resizable()
                  .scaledToFit()
                  .frame(width: 36, height: 36)
                Text(appState.getPartner().loadStatus.label)
                  .font(.system(size: 9, weight: .bold))
                  .foregroundColor(.appTextPrimary)
                  .multilineTextAlignment(.center)
                  .fixedSize(horizontal: false, vertical: true)
              }
              .frame(width: 80)
              .padding(4)
            }
          }
        }
        .padding()
        .background(Color.cardBackground)

        // Filters
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 12) {
            FilterChip(
              label: "すべて", isSelected: filterStatus == nil, action: { filterStatus = nil })
            FilterChip(
              label: "未完了", isSelected: filterStatus == .open,
              action: { filterStatus = .open })
            FilterChip(
              label: "完了済", isSelected: filterStatus == .done,
              action: { filterStatus = .done })

            Divider().frame(height: 20)

            FilterChip(
              label: "夫", isSelected: filterOwner == .husband,
              action: { filterOwner = .husband })
            FilterChip(
              label: "妻", isSelected: filterOwner == .wife, action: { filterOwner = .wife })
            FilterChip(
              label: "共同", isSelected: filterOwner == .both, action: { filterOwner = .both })
          }
          .padding()
        }

        // List
        ScrollView {
          LazyVStack(spacing: 12) {
            let filteredItems = appState.currentItems.filter { item in
              // Filter by Status
              if let status = filterStatus {
                if item.status != status { return false }
              }
              // Filter by Owner
              if let owner = filterOwner {
                if item.owner != owner { return false }
              }

              return true
            }.sorted(by: { $0.startAt < $1.startAt })

            ForEach(filteredItems) { item in
              NavigationLink(destination: ToDoDetailView(item: item)) {
                ToDoItemRow(item: item)
              }
              .buttonStyle(PlainButtonStyle())
              .padding(.horizontal)
              .contextMenu {
                Button(role: .destructive) {
                  appState.deleteItem(item)
                } label: {
                  Label("削除", systemImage: "trash")
                }
              }
            }
          }
          .padding(.bottom, 80)
        }
      }
      .navigationTitle("ToDoリスト")
      .background(Color.appBackground)
      .overlay(
        VStack {
          Spacer()
          HStack {
            Spacer()
            Button(action: { showAddSheet = true }) {
              Image(systemName: "plus")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding()
                .background(Color.appAccent)
                .clipShape(Circle())
                .shadow(radius: 4)
            }
            .padding()
          }
        }
      )
      .sheet(isPresented: $showAddSheet) {
        ToDoItemForm(isPresented: $showAddSheet)
      }
      .navigationBarHidden(true)
    }
  }
}

// MARK: - Helper Views

func getConditionImageName(for status: PartnerLoadStatus) -> String {
  switch status {
  case .struggling: return "condition_03"
  case .goingWell: return "condition_02"
  case .available: return "condition_01"
  }
}

struct ToDoDistributionBar: View {
  let items: [Item]

  var body: some View {
    let openItems = items.filter { $0.status == .open }
    let husbandOpen = Double(openItems.filter { $0.owner == .husband }.count)
    let wifeOpen = Double(openItems.filter { $0.owner == .wife }.count)
    let bothOpen = Double(openItems.filter { $0.owner == .both }.count)
    let totalOpen = husbandOpen + wifeOpen + bothOpen

    let doneItems = items.filter { $0.status == .done }
    let husbandDone = doneItems.filter { $0.owner == .husband }.count
    let wifeDone = doneItems.filter { $0.owner == .wife }.count
    let bothDone = doneItems.filter { $0.owner == .both }.count
    let totalDone = doneItems.count

    VStack(alignment: .leading, spacing: 8) {
      GeometryReader { geometry in
        HStack(spacing: 0) {
          if totalOpen > 0 {
            Rectangle()
              .fill(Color.supportBlue)
              .frame(width: geometry.size.width * (husbandOpen / totalOpen))
            Rectangle()
              .fill(Color.supportLavender)
              .frame(width: geometry.size.width * (wifeOpen / totalOpen))
            Rectangle()
              .fill(Color.appAccent)
              .frame(width: geometry.size.width * (bothOpen / totalOpen))
          } else {
            Rectangle()
              .fill(Color.gray.opacity(0.1))
          }
        }
        .cornerRadius(8)
      }
      .frame(height: 16)

      HStack {
        DistributionLabel(
          label: "夫", color: .supportBlue, openCount: Int(husbandOpen), doneCount: husbandDone)
        Spacer()
        DistributionLabel(
          label: "妻", color: .supportLavender, openCount: Int(wifeOpen), doneCount: wifeDone)
        Spacer()
        DistributionLabel(
          label: "共同", color: .appAccent, openCount: Int(bothOpen), doneCount: bothDone)
      }
    }
  }
}

struct DistributionLabel: View {
  let label: String
  let color: Color
  let openCount: Int
  let doneCount: Int

  var body: some View {
    HStack(spacing: 4) {
      Circle().fill(color).frame(width: 8, height: 8)
      Text("\(label) (未:\(openCount) 完:\(doneCount))")
        .font(.system(size: 10))
        .foregroundColor(.appTextSecondary)
    }
  }
}

struct StatusEmojiButton: View {
  let imageName: String
  let label: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 4) {
        Image(imageName)
          .resizable()
          .scaledToFit()
          .blendMode(.multiply)
          .frame(width: 44, height: 44)
        if isSelected {
          Text(label)
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(.appAccent)
            .frame(width: 85)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
      .padding(.vertical, 8)
      .padding(.horizontal, 4)
      .background(isSelected ? Color.appAccent.opacity(0.1) : Color.clear)
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(isSelected ? Color.appAccent : Color.clear, lineWidth: 1)
      )
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
