//
//  HomeView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var selectedTask: Task? // Track the selected task for detailed view
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    // Array of images
    let images = ["MainPicture1", "MainPicture2", "MainPicture3", "MainPicture4", "MainPicture5"] // Add your image names here
    @State private var selectedImage: String = "" // Holds the selected image name

    // Initializer to pick a random image when the view is created
    init() {
        _selectedImage = State(initialValue: images.randomElement() ?? "MainPicture1") // Choose a random image from the array
    }

    var body: some View {
        Group {
            if verticalSizeClass == .regular {
                VStack(spacing: 0) {
                    // ZStack for image and welcome text
                    ZStack(alignment: .bottomLeading) {
                        Image(selectedImage) // Display the randomly selected image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                            .edgesIgnoringSafeArea(.top) // Image ignores top safe area

                        Text("Welcome")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.leading, 50)
                            .padding(.bottom, 100)
                    }


                    // ScrollView containing the tasks
                    ScrollView {
                        VStack(spacing: 20) {
                            // Urgent Tasks Section
                            VStack(alignment: .leading, spacing: 10) {
                                Spacer()
                                Text("Urgent Tasks")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Text"))
                                    .padding(.horizontal)

                                if urgentTasks.isEmpty {
                                    Text("No urgent tasks")
                                        .font(.subheadline)
                                        .foregroundColor(Color("Text"))
                                        .padding(.horizontal)
                                } else {
                                    ForEach(urgentTasks) { task in
                                        Button(action: {
                                            selectedTask = task // Select the task for detailed view
                                        }) {
                                            taskCardView(task: task, isUrgent: true)
                                        }
                                    }
                                }
                            }

                            Divider().background(Color("Text")).padding(.horizontal)

                            // Today's Tasks Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Today's Tasks")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Text"))
                                    .padding(.horizontal)

                                if todaysTasks.isEmpty {
                                    Text("No tasks for today")
                                        .font(.subheadline)
                                        .foregroundColor(Color("Text"))
                                        .padding(.horizontal)
                                } else {
                                    ForEach(todaysTasks) { task in
                                        Button(action: {
                                            selectedTask = task // Select the task for detailed view
                                        }) {
                                            taskCardView(task: task)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 10) // Adding padding to avoid overlap with image
                    }
                    .padding(.top, -62)
                    .background(Color("Background")) // Set background color
                    .sheet(item: $selectedTask) { task in
                        TaskDetailView(task: task)
                            .presentationDetents([.fraction(0.3), .fraction(0.5)]) // Control the height
                            .presentationDragIndicator(.visible) // Optional drag indicator
                    }


                }
            } else {
                VStack(spacing: 0) {
                    // ScrollView containing the tasks
                    ScrollView {
                        ZStack(alignment: .bottomLeading) {
                            Image(selectedImage) // Display the randomly selected image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
//                                .frame(maxHeight: .infinity)
                                .clipped()
                                .edgesIgnoringSafeArea(.all) // Image ignores top safe area

                            Text("Welcome")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.leading, 50)
                                .padding(.bottom, 30)
                        }
                        VStack(spacing: 20) {
                            // Urgent Tasks Section
                            VStack(alignment: .leading, spacing: 10) {
                                Spacer()
                                Text("Urgent Tasks")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Text"))
                                    .padding(.horizontal)

                                if urgentTasks.isEmpty {
                                    Text("No urgent tasks")
                                        .font(.subheadline)
                                        .foregroundColor(Color("Text"))
                                        .padding(.horizontal)
                                } else {
                                    ForEach(urgentTasks) { task in
                                        Button(action: {
                                            selectedTask = task // Select the task for detailed view
                                        }) {
                                            taskCardView(task: task, isUrgent: true)
                                        }
                                    }
                                }
                            }

                            Divider().background(Color("Text")).padding(.horizontal)

                            // Today's Tasks Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Today's Tasks")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Text"))
                                    .padding(.horizontal)

                                if todaysTasks.isEmpty {
                                    Text("No tasks for today")
                                        .font(.subheadline)
                                        .foregroundColor(Color("Text"))
                                        .padding(.horizontal)
                                } else {
                                    ForEach(todaysTasks) { task in
                                        Button(action: {
                                            selectedTask = task // Select the task for detailed view
                                        }) {
                                            taskCardView(task: task)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 10) // Adding padding to avoid overlap with image
                    }
                    .padding(.top, -62)
                    .background(Color("Background")) // Set background color
                    .sheet(item: $selectedTask) { task in
                        TaskDetailView(task: task)
                            .presentationDetents([.fraction(0.3), .fraction(0.5)]) // Control the height
                            .presentationDragIndicator(.visible) // Optional drag indicator
                    }


                }
            }
        }
        .background(Color("Background")) // Set overall background color
    }

    // Filter for urgent tasks
    var urgentTasks: [Task] {
        taskViewModel.tasks.filter { $0.urgency == .high }
    }

    // Filter for today's tasks
    var todaysTasks: [Task] {
        let calendar = Calendar.current
        return taskViewModel.tasks.filter {
            calendar.isDateInToday($0.date)
        }
    }

    // Custom task card view (date in MM/DD format)
    @ViewBuilder
    func taskCardView(task: Task, isUrgent: Bool = false) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isUrgent ? .red : Color("Text"))
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(Color("Text"))
            }
            Spacer()
            // Display the date in MM/DD format
            Text(formatDate(task.date))
                .font(.subheadline)
                .foregroundColor(Color("Text"))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Cell"))
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("Cell"))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }

    // Helper function to format date in MM/DD format
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TaskViewModel()) // Inject the TaskViewModel for preview
    }
}
