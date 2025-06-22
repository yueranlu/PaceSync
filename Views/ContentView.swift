//
//  ContentView.swift
//  PaceSync (Frontend)
//
//  Created by Yueran Lu on 2025-06-07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing:40) {
            // top stat bar
                TopStatsView()
            // main infor for spm
                StepCircleMeter(stepsPerMinute: 135)
                .padding()
            // song display
                MusicBar()
            
            // stop start button
               StartStopButton()
            
            }
        }
    }

#Preview {
    ContentView()
}
