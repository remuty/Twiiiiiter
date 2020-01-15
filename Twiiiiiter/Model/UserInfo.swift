//
//  UserInfo.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/05.
//  Copyright © 2020 remuty. All rights reserved.
//

import Foundation
struct UserInfo: Codable {
    var data: Data
    struct Data: Codable {
        var id: Int
        var email: String
        var name: String
    }
}

