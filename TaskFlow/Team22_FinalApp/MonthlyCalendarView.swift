//
//  MonthlyCalendarView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//

import SwiftUI

struct MonthlyCalendarView: View {
    @Binding var currentDate: Date
    @EnvironmentObject var taskViewModel: TaskViewModel // Use TaskViewModel
    @State private var selectedDate: Date? // Track the selected date
    let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 20) {
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(daysInMonth(), id: \.self) { date in
                    // Determine if there are tasks for this date
                    let tasksForDay = tasks(for: date)

                    if tasksForDay.isEmpty {
                        Text(calendar.component(.day, from: date).description) // Non-clickable if no tasks
                            .foregroundColor(.gray)
                    } else {
                        // Make date clickable and color-coded
                        Button(action: {
                            selectedDate = date
                        }) {
                            Text(calendar.component(.day, from: date).description)
                                .fontWeight(.bold)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(tasksForDay.contains { $0.urgency == .high } ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
                                )
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding()

            Divider()

            // Show tasks for selected date
            if let date = selectedDate {
                VStack(alignment: .leading, spacing: 10) {
                    if tasks(for: date).isEmpty {
                        Text("No tasks for this day")
                            .font(.headline)
                    } else {
                        Text("Tasks for \(formatDate(date))")
                            .font(.title2)
                            .fontWeight(.bold)
                        ForEach(tasks(for: date)) { task in
                            taskRowView(task: task) // Display task row
                        }
                    }
                }
                .padding()
            }
        }
    }

    // Helper function to get all days in the current month
    func daysInMonth() -> [Date] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }

    // Helper function to format date to MM/dd format
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }

    // Filter tasks for a specific date
    func tasks(for date: Date) -> [Task] {
        taskViewModel.tasks.filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }

    // Row view for each task
    @ViewBuilder
    func taskRowView(task: Task) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.headline)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(task.date, style: .time) // Show task time
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 2)
        )
    }
}



