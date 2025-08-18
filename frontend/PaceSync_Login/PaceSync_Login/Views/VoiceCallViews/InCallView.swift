//
//  InCallView.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-08-15.
//

import SwiftUI
import LiveKit

struct InCallView: View {
    @ObservedObject var room: Room
    @Binding var callState: CallStates
    
    var body: some View {
        Button {
            callState = .disconnected
            
        } label: {
            ZStack {
                Image("endcall")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            }
            
        }
    }
}

#Preview {
    InCallView(room: Room(), callState: .constant(.connected))
}
