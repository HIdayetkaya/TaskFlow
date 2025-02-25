//
//  EditTaskView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//

import SwiftUI

struct EditTaskView: View {
    @State private var title: String
    @State private var description: String
    @State private var date: Date
    @State private var urgency: UrgencyLevel
    
    @Environment(\.presentationMode) var presentationMode // To dismiss the sheet
    var updateTask: (Task) -> Void // Closure to update the task

    var isFormValid: Bool {
        !title.isEmpty && !description.isEmpty
    }
    
    // Initialize with the existing task
    init(task: Task, updateTask: @escaping (Task) -> Void) {
        self._title = State(initialValue: task.title)
        self._description = State(initialValue: task.description)
        self._date = State(initialValue: task.date)
        self._urgency = State(initialValue: task.urgency)
        self.updateTask = updateTask
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("Background") // Set the background color for the entire view
                    .edgesIgnoringSafeArea(.all) // Extend the color to safe areas
                
                Form {
                    Section(header: Text("Task Details").foregroundColor(Color("Text"))) {
                        // Title Field
                        TextField("Title", text: $title)
                            .foregroundColor(Color("Text")) // Set text color

                        // Description Field
                        TextField("Description", text: $description)
                            .foregroundColor(Color("Text")) // Set text color

                        // Date Picker
                        DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .foregroundColor(Color("Text")) // Set text color

                        // Urgency Picker
                        Picker("Urgency", selection: $urgency) {
                            ForEach(UrgencyLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                        .foregroundColor(Color("Text")) // Set text color
                    }
                }
                .scrollContentBackground(.hidden) // Ensure form background matches main background
            }
            .navigationTitle("Edit Task")
            .toolbar {
                // Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }
                    .foregroundColor(Color("Text"))
                }

                // Save Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        let updatedTask = Task(
                            id: UUID(), // You can use the same ID as the original task if needed
                            title: title,
                            description: description,
                            date: date,
                            urgency: urgency
                        )
                        updateTask(updatedTask)
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }
                    .disabled(!isFormValid) // Disable if form is invalid
                    .foregroundColor(isFormValid ? Color("Text") : Color.gray)
                }
            }
        }
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleTask = Task(
            id: UUID(),
            title: "Doctor Appointment",
            description: "Visit Dr. Smith at 10 AM.",
            date: Date(),
            urgency: .high
        )
        
        EditTaskView(task: exampleTask) { updatedTask in
            print("Updated Task: \(updatedTask)")
        }
        .environment(\.colorScheme, .light) // Set light or dark mode for preview
    }
}
