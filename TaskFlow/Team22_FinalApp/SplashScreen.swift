//
//  SplashScreen.swift
//  Team22_FinalApp
//
//  Created by Hidayet Kaya on 12/5/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                ContentView().environmentObject(TaskViewModel())
            } else {
                VStack {
                    ZStack{
                        Image("MainPicture1")

                        Text("TaskFlow")
                            .foregroundColor(Color("Background"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                    }
                    
                
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Cell")) // Replace with your desired background color or gradient
                .ignoresSafeArea()
                .onAppear {
                    // Delay for 5 seconds before transitioning
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

