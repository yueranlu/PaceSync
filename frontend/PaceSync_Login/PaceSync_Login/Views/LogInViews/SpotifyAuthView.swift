//
//  SpotifyAuthView.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-07-16.
//

import SwiftUI

struct SpotifyAuthView: View {
    @StateObject var viewModel = MainViewViewModel()
    @StateObject private var spotifyController = SpotifyController()
    @Binding var path: NavigationPath
    var action: () -> Void

    var body: some View {
        if spotifyController.isAuthorized {
            HomepageView()
        }
        
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            Rectangle()
                .frame(width: 350, height: 300)
                .cornerRadius(5)
                .foregroundColor(Color.white)
            
            Text("Connect PaceSync to your")
                .font(.title)
                .padding()
                .frame(width: 380, alignment: .center)
                .offset(y: -100)
            
            Text("Spotify account")
                .font(.title)
                .padding()
                .frame(width: 380, alignment: .center)
                .offset(y: -65)
            
            Button {
                action()
                
                if !spotifyController.appRemote.isConnected {
                    spotifyController.authorize()
                }
                
                
            } label: {
                ZStack{
                    
                    Rectangle()
                        .cornerRadius(8)
                        .foregroundColor(.green)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        .frame(width: 300, height: 40)
                        .overlay(alignment: .center) {
                            Text("Connect with Spotify")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .offset(x:8)
                        }
                        .offset(y: 30)
                    
                    Image("spotify")
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .clipShape(Circle())
                        .frame(width: 150, height: 40)
                        .offset(x:-100, y: 30)
                }
            }


        }
        .onOpenURL { url in
            spotifyController.setAccessToken(from: url)
        }
        .environmentObject(spotifyController)
    }
}

#Preview {
    SpotifyAuthView(path: .constant(NavigationPath()), action: {})
}
