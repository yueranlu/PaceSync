// !! Note !!
// This sample hardcodes a token which expires in 2 hours.
let wsURL = "ws://localhost:7880"
let token = ""
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
        ZStack {
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
                Text("Disconnected")
                    .offset(y: 15)
            case .connected:
                InCallView(room: room, callState: .constant(.connected))
            case .connecting:
                Text("Connecting...")
            case .calling(let targetUser):
                Text("Calling \(targetUser)...")
            case .incomingCall(let fromUser):
                Text("Incoming call from \(fromUser)...")
            }
            
        }
        .padding()
        .environmentObject(room)
    }
}

#Preview {
    LiveKitCallsView()
}
