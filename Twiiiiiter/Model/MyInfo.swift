//
//  MyInfo.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/15.
//  Copyright © 2020 remuty. All rights reserved.
//

import Foundation
struct MyInfo: Codable {
    var posts: [Posts]
    struct Posts: Codable {
        var text: String
    }
}
