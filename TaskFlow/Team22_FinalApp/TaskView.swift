//
//  TaskView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var isDeleteMode: Bool = false // Toggle delete mode
    @State private var showingAddTaskView: Bool = false // For adding tasks
    @State private var selectedTask: Task? // Track the selected task for editing
    @State private var showingEditTaskView: Bool = false // For editing tasks

    var body: some View {
        NavigationView {
            VStack {
                // Custom toolbar with title, plus icon, and trash/done button
                HStack {
                    // Delete button (trash/done)
                    Button(action: {
                        isDeleteMode.toggle() // Toggle delete mode
                    }) {
                        Text(isDeleteMode ? "Done" : "Edit") // Change between "Trash" and "Done"
                            .foregroundColor(Color("Text"))
                            .font(.headline)
                    }

                    Spacer()

                    Text("Task Manager")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color("Text"))
                        .bold()



                    Spacer()

                    // Plus button for adding tasks
                    Button(action: {
                        showingAddTaskView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(Color("Text"))
                    }
                }
                .padding()

                // List of tasks with delete functionality
                List {
                    ForEach(taskViewModel.tasks) { task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .font(.headline) // Same font, slightly smaller
                                    .foregroundColor(Color("Text"))
                                Text("\(task.date, style: .time)")
                                    .font(.subheadline) // Smaller font for the date
                                    .foregroundColor(Color("Text"))
                            }
                            Spacer()

                            // Pencil icon for editing the task
                            Button(action: {
                                selectedTask = task
                                showingEditTaskView = true
                            }) {
                                Image(systemName: "pencil")
                                    .font(.title2)
                                    .foregroundColor(Color("Text"))
                            }
                        }
                        .padding(.vertical, 8) // Space between tasks
                    }
                    .onDelete { indexSet in
                        deleteTask(at: indexSet) // Swipe to delete if in delete mode
                    }
                    .listRowBackground(isDeleteMode ? Color.red.opacity(0.1) : Color.clear)
                }
                .environment(\.editMode, .constant(isDeleteMode ? EditMode.active : EditMode.inactive)) // Toggle edit mode
                .listStyle(PlainListStyle())
                
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddTaskView) {
                AddTaskView { title, description, date, urgency in
                    addTask(title: title, description: description, date: date, urgency: urgency)
                }
            }
            .sheet(item: $selectedTask) { task in
                EditTaskView(task: task, updateTask: updateTask)
            }
            .background(Color("Background"))
        }
    }

    // Function to add a new task
    private func addTask(title: String, description: String, date: Date, urgency: UrgencyLevel) {
        let newTask = Task(title: title, description: description, date: date, urgency: urgency)
        taskViewModel.tasks.append(newTask)
    }

    // Function to delete a task
    private func deleteTask(at indexSet: IndexSet) {
        taskViewModel.tasks.remove(atOffsets: indexSet)
    }

    // Function to update an existing task
    private func updateTask(updatedTask: Task) {
        if let index = taskViewModel.tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            taskViewModel.tasks[index] = updatedTask
        }
    }
}


struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
            .environmentObject(TaskViewModel()) // Provide TaskViewModel for preview
    }
}

