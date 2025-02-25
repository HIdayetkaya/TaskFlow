//
//  CalendarView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.


import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let monthDayFormatter: DateFormatter

    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @State private var selectedDate = Self.now
    @State private var isMonthlyView = true // Toggle between month and week view
    @State private var selectedTask: Task? // State to track the selected task for the detail view
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
        self.weekDayFormatter.dateFormat = "EEEE"
        self.weekDayFormatter.calendar = calendar

        self.monthDayFormatter = DateFormatter()
        self.monthDayFormatter.dateFormat = "MMM d"
        self.monthDayFormatter.calendar = calendar
    }

    var body: some View {
        Group {
            if verticalSizeClass == .regular {
                portraitView
            } else {
                landscapeView
            }
        }
        .background(Color("Background"))
        .sheet(item: $selectedTask) { task in
            TaskDetailView(task: task)
                .presentationDetents([.fraction(0.3), .fraction(0.5)]) // Control the height
                .presentationDragIndicator(.visible) // Optional drag indicator
        }
    }

    // MARK: - Portrait View
    @ViewBuilder
    var portraitView: some View {
        VStack {
            headerView
            calendarContent
            Spacer()
        }
    }

    // MARK: - Landscape View
    @ViewBuilder
    var landscapeView: some View {
        VStack {
            Spacer()
            headerView
                .padding(.top, 5)
            calendarContent
            Spacer()
        }
    }

    // MARK: - Header View
    var headerView: some View {
        Picker("", selection: $isMonthlyView) {
            Text("Month").tag(true)
            Text("Week").tag(false)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .background(Color("Background"))
        .onAppear {
            let appearance = UISegmentedControl.appearance()
            appearance.selectedSegmentTintColor = UIColor(Color("Cell"))
            appearance.setTitleTextAttributes([.foregroundColor: UIColor(Color("Text"))], for: .selected)
            appearance.setTitleTextAttributes([.foregroundColor: UIColor(Color("Text").opacity(0.7))], for: .normal)
        }
    }

    // MARK: - Calendar Content
    @ViewBuilder
    var calendarContent: some View {
        if isMonthlyView {
            monthView
        } else {
            weekView
        }
    }

    var monthView: some View {
        VStack {
            if verticalSizeClass == .regular {
                VStack {
                    calendarHeader
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                        ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                            Text(day)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color("Text"))
                        }
                        ForEach(daysInMonth(), id: \.self) { date in
                            Button(action: {
                                selectedDate = date
                            }) {
                                Text(dayFormatter.string(from: date))
                                    .padding(8)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("Text"))
                                    .background(calendar.isDateInToday(date) ? Color("Cell") :
                                        calendar.isDate(date, inSameDayAs: selectedDate) ? Color("Cell").opacity(0.5) : Color.clear)
                                    .cornerRadius(8)
                                    .overlay(taskIndicator(for: date), alignment: .bottomTrailing)
                            }
                        }
                    }
                }
                tasksContent
            } else {
                HStack {
                    VStack {
                        calendarHeader
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 8) {
                            ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                                Text(day)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(Color("Text"))
                            }
                            ForEach(daysInMonth(), id: \.self) { date in
                                Button(action: {
                                    selectedDate = date
                                }) {
                                    Text(dayFormatter.string(from: date))
                                        .padding(1)
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color("Text"))
                                        .background(calendar.isDateInToday(date) ? Color("Cell") :
                                            calendar.isDate(date, inSameDayAs: selectedDate) ? Color("Cell").opacity(0.5) : Color.clear)
                                        .cornerRadius(8)
                                        .overlay(taskIndicator(for: date), alignment: .bottomTrailing)
                                }
                            }
                        }
                        Spacer()
                    }
                    VStack {
                        tasksContent
                            .padding(.top, -30)
                    }
                    Spacer()
                }
            }
        }
    }

    var weekView: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    selectedDate = calendar.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color("Text"))
                }
                Spacer()
                Text(weekRange(for: selectedDate))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Text"))
                Spacer()
                Button(action: {
                    selectedDate = calendar.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(Color("Text"))
                }
                Spacer()
            }
            .padding()
            .background(Color("Background"))

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(daysInWeek(for: selectedDate), id: \.self) { date in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(weekDayFormatter.string(from: date))
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(monthDayFormatter.string(from: date))
                                    .font(.subheadline)
                                    .frame(width: 80, alignment: .trailing)
                            }
                            .foregroundColor(Color("Text"))

                            if !taskViewModel.tasksForDate(date).isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    ForEach(taskViewModel.tasksForDate(date)) { task in
                                        Button(action: {
                                            selectedTask = task // Select task for detail view
                                        }) {
                                            taskCardView(task: task)
                                        }
                                    }
                                }
                                .foregroundColor(Color("Text"))
                            } else {
                                Text("No tasks for today")
                                    .font(.subheadline)
                                    .foregroundColor(Color("Text"))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color("Background"))
    }

    var calendarHeader: some View {
        HStack {
            Spacer()
            Button(action: {
                selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
            }) {
                Image(systemName: "chevron.left")
            }
            .foregroundColor(Color("Text"))
            Spacer()
            Text(isMonthlyView ? monthFormatter.string(from: selectedDate) : weekRange(for: selectedDate))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("Text"))
            Spacer()
            Button(action: {
                selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
            }) {
                Image(systemName: "chevron.right")
            }
            .foregroundColor(Color("Text"))
            Spacer()
        }
    }

    // MARK: - Tasks Content
    @ViewBuilder
    var tasksContent: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Tasks for \(monthDayFormatter.string(from: selectedDate))")
                    .foregroundColor(Color("Text"))
                    .font(.headline)
                    .padding(.horizontal)
                if !taskViewModel.tasksForDate(selectedDate).isEmpty {
                    ForEach(taskViewModel.tasksForDate(selectedDate)) { task in
                        Button(action: {
                            selectedTask = task // Set the selected task
                        }) {
                            taskCardView(task: task)
                        }
                        .sheet(item: $selectedTask) { task in
                            TaskDetailView(task: task)
                                .presentationDetents([.fraction(0.3), .fraction(0.5)]) // Control the height
                                .presentationDragIndicator(.visible) // Optional drag indicator
                        }


                    }
                } else {
                    Text("No tasks for today")
                        .font(.subheadline)
                        .foregroundColor(Color("Text"))
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Helpers
    @ViewBuilder
    private func taskIndicator(for date: Date) -> some View {
        let tasks = taskViewModel.tasksForDate(date)
        let hasHighUrgency = tasks.contains { $0.urgency == .high }
        if !tasks.isEmpty {
            Circle()
                .fill(hasHighUrgency ? Color.red : Color.blue)
                .frame(width: 8, height: 8)
                .offset(x: -5, y: 5)
        }
    }

    func daysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else { return [] }
        let firstDayOfMonth = calendar.component(.weekday, from: monthInterval.start) - 1
        let monthDays = calendar.generateDates(for: monthInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
        return Array(repeating: Date.distantPast, count: firstDayOfMonth) + monthDays
    }

    func weekRange(for date: Date) -> String {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else { return "" }
        let startDate = weekInterval.start
        let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) ?? startDate
        return "\(monthDayFormatter.string(from: startDate)) - \(monthDayFormatter.string(from: endDate))"
    }

    func daysInWeek(for date: Date) -> [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else { return [] }
        return calendar.generateDates(for: weekInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }

    private func taskCardView(task: Task) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(Color("Text"))
                Text(task.urgency.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundColor(task.urgency == .high ? .red : .blue)
            }
            Spacer()
            Text(task.date, style: .time)
                .font(.subheadline)
                .foregroundColor(Color("Text"))

        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color("Cell")))
    }
}

extension Calendar {
    func generateDates(for dateInterval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates = [dateInterval.start]
        enumerateDates(startingAfter: dateInterval.start, matching: components, matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date else { return }
            guard date < dateInterval.end else { stop = true; return }
            dates.append(date)
        }
        return dates
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(TaskViewModel())
    }
}

