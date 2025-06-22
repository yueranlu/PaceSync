import SwiftUI


struct StepCircleMeter: View {
    @ObservedObject var tracker: StepTracker
    
    let maxSteps: Double
    
    var progress: Double {
        min(tracker.currentSPM / maxSteps, 1.0)
    }

    var body: some View {
        ZStack {
            circleBar(color: Color(hex: "#021bf9"), progress: progress)
                .frame(width: 175, height: 175)
   
            
            // Text in the center
            VStack(spacing: 4) {
                Text("Steps/Min")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(Int(tracker.currentSPM))")
                    .font(.title)
                    .bold()
            }
        }
        .frame(width: 140, height: 140)
    }
}

struct circleBar: View {
    
    let color: Color
    let progress: Double
    var body: some View{
        
        ZStack{
            Circle()
                .stroke(lineWidth:40)
                .opacity(0.1)
                .foregroundStyle(color)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .round))
                .foregroundStyle(color)
                .rotationEffect(.degrees(90))
                .foregroundStyle(color)
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
}
#Preview {
    // ✅ Create a dummy StepTracker with mock data for preview
    let dummyTracker = StepTracker()
    dummyTracker.currentSPM = 100 // Simulated SPM value

    return StepCircleMeter(tracker: dummyTracker, maxSteps: 250)
}
