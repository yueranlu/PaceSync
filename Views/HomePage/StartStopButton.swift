import SwiftUI

// Same reusable StartStopButton
struct StartStopButton: View {
    @StateObject private var tracker = StepTracker()
    @State private var isRunning = false
    
    let onStart: (() -> Void)?
    let onStop: (() -> Void)?
    
    init(onStart: (() -> Void)? = nil, onStop: (() -> Void)? = nil) {
        self.onStart = onStart
        self.onStop = onStop
    }
    
    var body: some View {
        Button(action: {
            if isRunning {
                tracker.stopTracking()
                onStop?()
            } else {
                tracker.startTracking()
                onStart?()
            }
            isRunning.toggle()
        }) {
            Text(isRunning ? "Stop" : "Start")
        }
        .font(.title)
        .fontWeight(.bold)
        .buttonStyle(.borderedProminent)
        .frame(width: 200)
    }
}
