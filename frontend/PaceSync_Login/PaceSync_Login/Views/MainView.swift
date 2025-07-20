//
//  MainView.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-06-21.
//

//THIS IS A TEMPORARY MAIN VIEW, CODE MIGHT BE USEFUL FOR THE FUTURE MAIN VIEW

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    @StateObject private var spotifyController = SpotifyController()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty{
            HomepageView()
        } else {
            LogInView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
