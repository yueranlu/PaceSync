// !! Note !!
// This sample hardcodes a token which expires in 2 hours.
let wsURL = "ws://localhost:7880"
let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoibXkgbmFtZSIsInZpZGVvIjp7InJvb21Kb2luIjp0cnVlLCJyb29tIjoibXktcm9vbSIsImNhblB1Ymxpc2giOnRydWUsImNhblN1YnNjcmliZSI6dHJ1ZSwiY2FuUHVibGlzaERhdGEiOnRydWV9LCJzdWIiOiJpZGVudGl0eSIsImlzcyI6ImRldmtleSIsIm5iZiI6MTc1NTAzMDA1MywiZXhwIjoxNzU1MDUxNjUzfQ.VTenhk5WI8AWx1OVgkwObTeGFbk7eHF6iyz5PZAmSMw"
// In production you should generate tokens on your server, and your client
// should request a token from your server.
@preconcurrency import LiveKit
import LiveKitComponents
import SwiftUI

struct LiveKitCallsView: View {
    @StateObject private var room: Room
    @State private var callStates: CallStates = .disconnected

    init() {
        let room = Room()
        _room = StateObject(wrappedValue: room)
    }

    var body: some View {
        Group { 
            if room.connectionState == .disconnected {
                Button("Connect") {
                    Task {
                        do {
                            try await room.connect(
                                url: wsURL,
                                token: token,
                                connectOptions: ConnectOptions(enableMicrophone: true)
                            )
                            try await room.localParticipant.setCamera(enabled: true)
                        } catch {
                            print("Failed to connect to LiveKit: \(error)")
                        }
                    }
                }
            } else {
                LazyVStack {
                    ForEachParticipant { _ in
                        VStack {
                            ForEachTrack(filter: .video) { trackReference in
                                VideoTrackView(trackReference: trackReference)
                                    .frame(width: 500, height: 500)
                            }
                        }
                    }
                }
            }
            switch callStates {
            case .disconnected:
                LiveKitCallsView()
            case .connected:
                InCallView(room: room)
            case .connecting:
                Text("Connecting...")
            case .ended:
                Text("will be added")
            case .calling(let targetUser):
                Text("will be added")
            case .incomingCall(let fromUser):
                Text("will be added")
            }
            
        }
        .padding()
        .environmentObject(room)
    }
}

#Preview {
    LiveKitCallsView()
}
