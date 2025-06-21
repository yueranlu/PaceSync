//
//  PaceSync_LoginApp.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-06-09.
//

import SwiftUI
import FirebaseCore

@main
struct PaceSync_LoginApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            LogInView()
        }
    }
}
