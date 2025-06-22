import SwiftUI
//  StartStopButton.swift
//  PaceSync (Frontend)
//
//  Created by Yueran Lu on 2025-06-11.
//

struct StartStopButton: View{
    @StateObject private var tracker = StepTracker()
    @State private var isRunning = false
    
    var body: some View{
        Button(action: {
           
            if isRunning{
                tracker.startTracking()
            }
            else{
                tracker.stopTracking()
            }
            isRunning.toggle()
        })
        {
            Text(isRunning ? "Start" : "Stop")
        }
        .font(.title)
        .fontWeight(.bold)
        .buttonStyle(.borderedProminent)
        .frame(width: 200)
        
    }
    
}

 #Preview {
     StartStopButton()
         .environmentObject(StepTracker()) // only if StepTracker expects this
 }

