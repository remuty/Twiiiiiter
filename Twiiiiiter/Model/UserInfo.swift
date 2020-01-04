//
//  UserInfo.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/05.
//  Copyright © 2020 remuty. All rights reserved.
//

import Foundation
struct UserInfo: Codable {
    var id: Int
    var text: String
    struct User: Codable {
        var name: String
    }
}
