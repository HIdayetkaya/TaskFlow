//
//  TaskViewModel.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [
        Task(title: "Grocery Shopping", description: "Buy vegetables", date: Date(), urgency: .low),
        Task(title: "Doctor Appointment", description: "Visit Dr. Smith", date: Date().addingTimeInterval(3600), urgency: .high),
        Task(title: "Finish Project", description: "Complete the final report", date: Date().addingTimeInterval(7200), urgency: .medium)
    ]
    
    // Method to get tasks for a specific date
    func tasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
}



