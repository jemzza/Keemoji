//
//  UserProfile.swift
//  Keemoji
//
//  Created by Alexander on 14.02.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

struct UserProfile {
    
    let id: Int?
    let name: String?
    let email: String?

    init(data: [String: Any]) {
        let id = data["id"] as? Int
        let name = data["name"] as? String
        let email = data["email"] as? String
        self.id = id
        self.name = name
        self.email = email
    }
}
