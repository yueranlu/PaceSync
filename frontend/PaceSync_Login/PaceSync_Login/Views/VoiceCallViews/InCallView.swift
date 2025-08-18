//
//  InCallView.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-08-15.
//

import SwiftUI

struct InCallView: View {
    @StateObject var mainView = LiveKitCallsView()
    var body: some View {
        Button {
            
            
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
    InCallView()
}
