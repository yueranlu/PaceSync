//
//  SpotifyController.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-07-16.
//

import Foundation
import SpotifyiOS
import Combine

private var connectCancellable: AnyCancellable?
private var disconnectCancellable: AnyCancellable?

@MainActor
final class SpotifyController: NSObject, ObservableObject, SPTAppRemoteDelegate {
    @Published var isAuthorized = false
    
    nonisolated func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("Spotify connected")
    }
    
    nonisolated func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: (any Error)?) {
        print("Spotify failed to connect: \(String(describing: error))")
    }
    
    nonisolated func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: (any Error)?) {
        print("Spotify disconnected: \(String(describing: error))")
    }
    
    let spotifyClientID = "b55d399d11934dfc9cc4941ef3d40e2b"
    let spotifyRedirectURL = URL(string:"pacesync-login://callback")!
    
    var accessToken: String? = nil
    
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters( from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
            isAuthorized = true
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            // Handle the error
        }
    }
    
    func authorize() {
        self.appRemote.authorizeAndPlayURI("")
    }
    
    lazy var configuration = SPTConfiguration(
        clientID: spotifyClientID,
        redirectURL: spotifyRedirectURL
    )

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()

    func connect() {
        if let _ = self.appRemote.connectionParameters.accessToken {
            appRemote.connect()
        }
    }

    func disconnect() {
        if appRemote.isConnected {
            appRemote.disconnect()
        }
    }
    
    override init() {
        super.init()
        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.connect()
            }
        
        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.disconnect()
            }
    }
}
