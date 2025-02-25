//
//  WeeklyCalendarView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//


import SwiftUI

struct WeeklyCalendarView: View {
    @Binding var currentDate: Date

    let columns = Array(repeating: GridItem(.flexible()), count: 7) // 7 columns for 7 days of the week

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
                // Display the days for the current week
                ForEach(daysInWeek(for: currentDate), id: \.self) { day in
                    VStack {
                        Text(weekdaySymbol(for: day))
                        Text("\(Calendar.current.component(.day, from: day))")
                            .frame(minWidth: 40, minHeight: 40)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }

    // Helper function to generate the days of the current week
    func daysInWeek(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: date)?.start ?? Date()
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    // Helper function to get the weekday symbol (Sun, Mon, etc.)
    func weekdaySymbol(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

struct WeeklyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCalendarView(currentDate: .constant(Date()))
    }
}

