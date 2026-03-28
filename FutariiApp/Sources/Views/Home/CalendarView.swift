import SwiftUI

struct CalendarView: View {
  let currentDate: Date
  let items: [Item]
  let accentColor: Color

  @State private var displayMonth: Date = Date()
  @State private var selectedDate: Date? = Date()

  private let calendar = Calendar.current
  private let daysOfWeek = ["日", "月", "火", "水", "木", "金", "土"]

  var body: some View {
    VStack(spacing: 12) {
      // Header: Month
      HStack {
        Button(action: {
          displayMonth =
            calendar.date(byAdding: .month, value: -1, to: displayMonth) ?? displayMonth
        }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.appTextPrimary)
        }

        Spacer()

        Text(monthString(from: displayMonth))
          .font(.appHeadline)
          .foregroundColor(.appTextPrimary)

        Spacer()

        Button(action: {
          displayMonth = calendar.date(byAdding: .month, value: 1, to: displayMonth) ?? displayMonth
        }) {
          Image(systemName: "chevron.right")
            .foregroundColor(.appTextPrimary)
        }
      }
      .padding(.bottom, 8)

      // Days of Week
      HStack {
        ForEach(daysOfWeek, id: \.self) { day in
          Text(day)
            .font(.appCaption)
            .foregroundColor(.appTextSecondary)
            .frame(maxWidth: .infinity)
        }
      }

      // Dates Grid
      let days = daysInMonth(for: displayMonth)
      let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

      LazyVGrid(columns: columns, spacing: 8) {
        ForEach(days.indices, id: \.self) { index in
          if let date = days[index] {
            let dayItems = items.filter { calendar.isDate($0.startAt, inSameDayAs: date) }
            let isSelected = isSameDay(date, selectedDate)
            let isTodayDate = isToday(date)
            let isPastDate = isPast(date)

            VStack(alignment: .leading, spacing: 4) {
              HStack {
                Spacer()
                Text("\(calendar.component(.day, from: date))")
                  .font(
                    .system(
                      size: 14, weight: isTodayDate || isSelected ? .bold : .medium,
                      design: .rounded)
                  )
                  .foregroundColor(
                    dateNumberForegroundColor(
                      isToday: isTodayDate, isSelected: isSelected, isPast: isPastDate)
                  )
                  .frame(width: 24, height: 24)
                  .background(
                    Circle()
                      .fill(dateNumberBackgroundColor(isToday: isTodayDate, isSelected: isSelected))
                  )
                Spacer()
              }

              // Item Labels
              VStack(spacing: 2) {
                ForEach(dayItems.prefix(2)) { item in
                  ItemLabel(item: item, isPast: isPastDate)
                }

                if dayItems.count > 2 {
                  Text("+\(dayItems.count - 2)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(
                      isPastDate ? .appTextSecondary.opacity(0.5) : .appTextSecondary
                    )
                    .padding(.leading, 4)
                }
              }

              Spacer(minLength: 0)
            }
            .frame(height: 90)
            .padding(.vertical, 4)
            .background(isSelected ? Color.appTextPrimary.opacity(0.05) : Color.clear)
            .cornerRadius(12)
            .onTapGesture {
              selectedDate = date
            }
          } else {
            Spacer().frame(height: 90)
          }
        }
      }
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 16)
    .background(Color.cardBackground)
    .cornerRadius(24)
    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
  }

  // Helper View for Labels
  private struct ItemLabel: View {
    let item: Item
    let isPast: Bool

    var body: some View {
      Text(item.title)
        .font(.system(size: 10, weight: .medium))
        .lineLimit(1)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor.opacity(isPast ? 0.4 : 1.0))
        .foregroundColor(foregroundColor.opacity(isPast ? 0.6 : 1.0))
        .cornerRadius(6)
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(borderColor.opacity(isPast ? 0.2 : 0.4), lineWidth: item.type == .todo ? 1 : 0)
        )
    }

    private var backgroundColor: Color {
      if item.type == .event {
        switch item.owner {
        case .husband: return .supportBlue
        case .wife: return .supportLavender
        case .both: return .appAccent
        }
      } else {  // todo
        switch item.owner {
        case .husband: return .supportBlueLight
        case .wife: return .supportLavenderLight
        case .both: return .supportCoralLight
        }
      }
    }

    private var foregroundColor: Color {
      if item.type == .event {
        return .white
      } else {
        switch item.owner {
        case .husband: return .supportBlue
        case .wife: return .supportLavender
        case .both: return .appAccent
        }
      }
    }

    private var borderColor: Color {
      switch item.owner {
      case .husband: return .supportBlue
      case .wife: return .supportLavender
      case .both: return .appAccent
      }
    }
  }

  // UI Helpers
  private func dateNumberForegroundColor(isToday: Bool, isSelected: Bool, isPast: Bool) -> Color {
    if isToday || isSelected {
      return .white
    }
    if isPast {
      return .appTextSecondary.opacity(0.4)
    }
    return .appTextPrimary
  }

  private func dateNumberBackgroundColor(isToday: Bool, isSelected: Bool) -> Color {
    if isToday {
      return accentColor
    }
    if isSelected {
      return .appTextPrimary
    }
    return .clear
  }

  // Helper Methods
  func monthString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.dateFormat = "yyyy年 M月"
    return formatter.string(from: date)
  }

  func isToday(_ date: Date) -> Bool {
    calendar.isDateInToday(date)
  }

  func isSameDay(_ date1: Date, _ date2: Date?) -> Bool {
    guard let date2 = date2 else { return false }
    return calendar.isDate(date1, inSameDayAs: date2)
  }

  func isPast(_ date: Date) -> Bool {
    let today = calendar.startOfDay(for: Date())
    let target = calendar.startOfDay(for: date)
    return target < today
  }

  func daysInMonth(for date: Date) -> [Date?] {
    guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
    let monthStart = monthInterval.start

    let firstActiveWeekday = calendar.component(.weekday, from: monthStart)
    let offset = firstActiveWeekday - 1  // 0 if Sunday

    var days: [Date?] = Array(repeating: nil, count: offset)

    let range = calendar.range(of: .day, in: .month, for: date)!
    for day in 1...range.count {
      if let d = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
        days.append(d)
      }
    }

    while days.count % 7 != 0 {
      days.append(nil)
    }

    return days
  }
}
