//
//  TaskDetailView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//

import SwiftUI

struct TaskDetailView: View {
    let task: Task
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    var body: some View {
        VStack{
            if verticalSizeClass == .regular {
                ZStack {
                    Color("Background")
                        .ignoresSafeArea(.all)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Spacer()
                        // "Done" button at the top
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Dismiss the view
                            }) {
                                Text("Done")
                                    .foregroundColor(Color("Text"))
                                    .font(.headline)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Task details
                        VStack(alignment: .leading, spacing: 10) {
                            Text(task.title)
                                .foregroundColor(Color("Text"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Date: \(task.date, style: .date)")
                                .foregroundColor(Color("Text"))
                                .font(.title3)
                            
                            Text("Time: \(task.date, style: .time)")
                                .font(.title3)
                                .foregroundColor(Color("Text").opacity(0.8))
                            
                            Text(task.description)
                                .font(.body)
                                .foregroundColor(Color("Text").opacity(0.8))
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom) // Minimal padding for aesthetics
                    .cornerRadius(15) // Add rounded corners for the pop-up style
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
                }
                    
                    Spacer()
                
            } else {
                ZStack {
                    // Set the background color for the entire screen
                    Color("Background")
                        .ignoresSafeArea(.all)
                    
                    HStack {
                        VStack{
                            HStack {
                                VStack {
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                                    }) {
                                        Text("Done")
                                            .foregroundColor(Color("Text"))
                                            .font(.headline)
                                    }
                                }
                                .background(Color("Background"))
                                .ignoresSafeArea(.all)
                                .padding()
                                .padding(.top)
                                Spacer()
                            }
                            
                            // Task details
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(task.title)
                                        .foregroundColor(Color("Text"))
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    
                                    Text("Date: \(task.date, style: .date)")
                                        .foregroundColor(Color("Text"))
                                        .font(.title3)
                                    
                                    Text("Time: \(task.date, style: .time)")
                                        .font(.title3)
                                        .foregroundColor(Color("Text").opacity(0.8))
                                    
                                    Text(task.description)
                                        .font(.body)
                                        .foregroundColor(Color("Text").opacity(0.8))
                                    Spacer()
                                }
                                .padding(.leading, 80)
                                .background(Color("Background"))
                                .ignoresSafeArea(.all)
                                Spacer()
                            }
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }

            }
            }

        }
    }



struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Example task for preview
        let exampleTask = Task(
            id: UUID(),
            title: "Doctor Appointment",
            description: "Visit Dr. Smith at 10 AM.",
            date: Date(),
            urgency: .high
        )

        TaskDetailView(task: exampleTask)
            .background(Color("Background"))
    }
}
