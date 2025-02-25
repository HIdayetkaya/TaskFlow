//
//  SimpleCalendarView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.


import SwiftUI

struct SimpleCalendarView: View {
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    
    @State private var selectedDate = Self.now
    private static var now = Date()
    
    init(calendar: Calendar = Calendar(identifier: .gregorian)) {
        self.calendar = calendar

        self.monthFormatter = DateFormatter()
        self.monthFormatter.dateFormat = "MMMM YYYY"
        self.monthFormatter.calendar = calendar

        self.dayFormatter = DateFormatter()
        self.dayFormatter.dateFormat = "d"
        self.dayFormatter.calendar = calendar

        self.weekDayFormatter = DateFormatter()
        self.weekDayFormatter.dateFormat = "EEE"
        self.weekDayFormatter.calendar = calendar
    }

    
    var body: some View {
        VStack {
            calendarHeader
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                // Weekday headers
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                
                // Days in the month
                ForEach(daysInMonth(), id: \.self) { date in
                    Button(action: {
                        selectedDate = date
                    }) {
                        Text(dayFormatter.string(from: date))
                            .padding(8)
                            .frame(width: 40, height: 40)
                            .foregroundColor(calendar.isDateInToday(date) ? .white : .primary)
                            .background(
                                calendar.isDateInToday(date) ? Color.red :
                                    calendar.isDate(date, inSameDayAs: selectedDate) ? Color.blue : Color.clear
                            )
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
    }
    
    var calendarHeader: some View {
        HStack {
            Button(action: {
                selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
            }
            Spacer()
            Text(monthFormatter.string(from: selectedDate))
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
            }) {
                Image(systemName: "chevron.right")
                    .font(.title2)
            }
        }
        .padding(.horizontal)
    }
    
    // Generate the days in the current month
    func daysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
            return []
        }
        
        var days: [Date] = []
        let startDate = monthInterval.start
        var currentDate = startDate
        
        while currentDate < monthInterval.end {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
}

#if DEBUG
struct SimpleCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleCalendarView()
    }
}
#endif
