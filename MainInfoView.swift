import SwiftUI


struct StepCircleMeter: View {
    @ObservedObject var tracker: StepTracker
    
    var stepsPerMinute: Double
    let maxSteps: Double = 250
    
    var progress: Double {
        min(stepsPerMinute / maxSteps, 1.0)
    }

    var body: some View {
        ZStack {
            circleBar(color: Color(hex: "#021bf9"))
                .frame(width: 175, height: 175)
   
            
            // Text in the center
            VStack(spacing: 4) {
                Text("Steps/Min")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(Int(stepsPerMinute))")
                    .font(.title)
                    .bold()
            }
        }
        .frame(width: 140, height: 140)
    }
}

struct circleBar: View {
    
    let color: Color
    var body: some View{
        
        ZStack{
            Circle()
                .stroke(lineWidth:40)
                .opacity(0.1)
                .foregroundStyle(color)
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .round))
                .foregroundStyle(color)
        }
    }
}
#Preview {
    StepCircleMeter(stepsPerMinute: 10)
}
