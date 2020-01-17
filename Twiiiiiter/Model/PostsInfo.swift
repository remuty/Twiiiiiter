//
//  PostsInfo.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/15.
//  Copyright © 2020 remuty. All rights reserved.
//

import Foundation
struct PostsInfo: Codable {
    var id: Int
    var text: String
    var user_id: Int
    var user: User
    struct User: Codable {
        var name: String
    }
}
