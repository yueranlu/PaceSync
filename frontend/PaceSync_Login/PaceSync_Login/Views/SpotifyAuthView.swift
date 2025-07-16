//
//  SpotifyAuthView.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-07-16.
//

import SwiftUI

struct SpotifyAuthView: View {
    @StateObject private var spotifyController = SpotifyController()

    var body: some View {
        ZStack {
            Button {
                if !spotifyController.appRemote.isConnected {
                    spotifyController.authorize()
                }
            } label: {
                // Button styling code here...
            }
        }
        .onOpenURL { url in
            spotifyController.setAccessToken(from: url)
        }
        .environmentObject(spotifyController)
    }
}

#Preview {
    SpotifyAuthView()
}
