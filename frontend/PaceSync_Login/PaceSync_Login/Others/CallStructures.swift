//
//  CallStructures.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-08-18.
//

import Foundation

enum CallStates {
    case disconnected
    case connected
    case connecting
    case calling(targetUser: String)
    case incomingCall(fromUser: String)
}
