//
//  AddTaskView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//

import SwiftUI

struct AddTaskView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var urgency: UrgencyLevel = .low
    
    @Environment(\.presentationMode) var presentationMode // To dismiss the sheet
    var addTask: (String, String, Date, UrgencyLevel) -> Void // Closure to add a task

    var isFormValid: Bool {
        !title.isEmpty && !description.isEmpty
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("Background") // Set the background color for the entire view
                    .edgesIgnoringSafeArea(.all) // Extend the color to safe areas
                
                Form {
                    Section(header: Text("Task Details").foregroundColor(Color("Text"))) {
                        TextField("Title", text: $title)
                            .foregroundColor(Color("Text")) // Text field text color
                        TextField("Description", text: $description)
                            .foregroundColor(Color("Text")) // Text field text color
                        DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .foregroundColor(Color("Text")) // Date picker text color

                        // Urgency level picker
                        Picker("Urgency", selection: $urgency) {
                            ForEach(UrgencyLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                        .foregroundColor(Color("Text")) // Picker text color
                    }
                }
                .scrollContentBackground(.hidden) // Ensure the form doesn't have its own background
            }
            .navigationTitle("Add New Task")
            .toolbar {
                // Cancel button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color("Text")) // Cancel button color
                }

                // Done button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addTask(title, description, date, urgency)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                            .bold()
                    }
                    .disabled(!isFormValid) // Disable the button if the form is invalid
                    .foregroundColor(isFormValid ? Color("Text") : Color.gray) // Change color based on form validity
                }
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView { title, description, date, urgency in
            print("Task Added:")
            print("Title: \(title)")
            print("Description: \(description)")
            print("Date: \(date)")
            print("Urgency: \(urgency.rawValue)")
        }
        .environment(\.colorScheme, .dark) // For dark mode preview
    }
}


