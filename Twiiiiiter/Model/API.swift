//
//  API.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/05.
//  Copyright © 2020 remuty. All rights reserved.
//

import Foundation

struct API {

    static func fetchUserInfo(completion: @escaping ([UserInfo]) -> Swift.Void) {
        
        
        let url = "https://ls123server.herokuapp.com/posts.json"
        
        guard var urlComponents = URLComponents(string: url) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "50"),
        ]
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let info = try JSONDecoder().decode([UserInfo].self, from: jsonData)
                completion(info)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
