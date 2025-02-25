//
//  ContentView.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskViewModel = TaskViewModel() // Shared view model
    @State private var selectedTab: Int = 1 // Default to Home tab (index 1)

    var body: some View {
        TabView(selection: $selectedTab) {
            // Calendar tab on the left
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(0) // Tag for Calendar
                .environmentObject(taskViewModel) // Pass TaskViewModel to CalendarView

            // Home tab in the middle
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(1) // Tag for Home
                .environmentObject(taskViewModel) // Pass TaskViewModel to HomeView

            // Task tab on the right
            TaskView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle.fill")
                }
                .tag(2) // Tag for Tasks
                .environmentObject(taskViewModel) // Pass TaskViewModel to TaskView
        }
        .onAppear {
            // Custom tab bar appearance configuration
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor(Color("Tab"))
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color("Text"))
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color("Background"))
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color("Text"))]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color("Background"))]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TaskViewModel()) // Provide TaskViewModel for the preview
    }
}






