//
//  User.swift
//  PaceSync_Login
//
//  Created by Dongshen Guan on 2025-06-21.
//

import Foundation

struct User: Codable {
    let id: String
    let username: String
    let email: String
    let joined: TimeInterval
}
