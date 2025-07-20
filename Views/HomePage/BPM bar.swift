import SwiftUI

struct SPMControlView: View {
    @State private var isManualMode = false
    @State private var spm: Double = 120 // Steps per minute
    @State private var isAdjustingSPM = false
    
    // Calculate pace from SPM (using average stride length) in min/km
    // Average stride length is approximately 0.7 meters
    // For running: pace = 1000 / (spm * stride_length_in_meters * 60)
    private var pace: String {
        let averageStrideInMeters = 0.7
        let metersPerMinute = spm * averageStrideInMeters
        let minutesPerKilometer = 1000 / metersPerMinute
        
        let minutes = Int(minutesPerKilometer)
        let seconds = Int((minutesPerKilometer - Double(minutes)) * 60)
        
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Mode toggle button
            Button(action: {
                isManualMode.toggle()
            }) {
                HStack {
                    Image(systemName: isManualMode ? "hand.tap" : "automaticdoor")
                    Text(isManualMode ? "Manual" : "Automatic")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isManualMode ? Color.blue : Color.green)
                .cornerRadius(8)
            }
            
                if isManualMode {
                    VStack(spacing: 15) {
                        // Audio waveform visualization - only when adjusting SPM
                        if isAdjustingSPM {
                            HStack(spacing: 4) {
                                ForEach(0..<20, id: \.self) { index in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(getBarColor(index: index))
                                        .frame(width: 6, height: getBarHeight(index: index))
                                        .animation(.easeInOut(duration: 0.5).repeatForever(), value: spm)
                                }
                            }
                            .frame(height: 80)
                            .transition(.opacity.combined(with: .scale))
                        }
                        
                        // SPM Control
                        VStack(spacing: 10) {
                            Text("Steps Per Minute")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("\(Int(spm)) SPM")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            
                            HStack {
                                Button("-") {
                                    if spm > 60 {
                                        withAnimation {
                                            isAdjustingSPM = true
                                            spm -= 5
                                        }
                                        // Hide waveform after a delay
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            withAnimation {
                                                isAdjustingSPM = false
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(SPMButtonStyle())
                                
                                Slider(value: $spm, in: 60...200, step: 5) { isEditing in
                                    withAnimation {
                                        isAdjustingSPM = isEditing
                                    }
                                }
                                .accentColor(.blue)
                                .frame(maxWidth: 200)
                                
                                Button("+") {
                                    if spm < 200 {
                                        withAnimation {
                                            isAdjustingSPM = true
                                            spm += 5
                                        }
                                        // Hide waveform after a delay
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            withAnimation {
                                                isAdjustingSPM = false
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(SPMButtonStyle())
                            }
                            
                            // Pace display
                            VStack {
                                Text("Pace")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(pace) min/km")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
        }
        .padding()
    }
    
    // Generate bar heights for waveform effect
    private func getBarHeight(index: Int) -> CGFloat {
        let baseHeight: CGFloat = 20
        let maxHeight: CGFloat = 60
        
        // Create a waveform pattern that changes based on SPM
        let frequency = spm / 60.0 // Normalize SPM
        let phase = Double(index) * 0.5 + Date().timeIntervalSince1970 * frequency
        let amplitude = sin(phase) * 0.5 + 0.5 // Normalize to 0-1
        
        return baseHeight + (maxHeight - baseHeight) * amplitude
    }
    
    // Generate bar colors for waveform effect
    private func getBarColor(index: Int) -> Color {
        let intensity = getBarHeight(index: index) / 60.0
        
        if intensity > 0.7 {
            return .blue
        } else if intensity > 0.4 {
            return .blue.opacity(0.7)
        } else {
            return .gray.opacity(0.5)
        }
    }
}

// Custom button style for SPM controls
struct SPMButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .background(Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
