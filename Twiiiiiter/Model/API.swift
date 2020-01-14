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
    
    static func postText(text: String){
        
        let urlString = "https://ls123server.herokuapp.com/posts"
        
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "text": "\(text)",
            "user_id": 1
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                let resultData = String(data: data!, encoding: .utf8)!
                print("result:\(resultData)")
                print("response:\(response)")
                
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }
    }
    
    static func register(name: String,email: String,password: String,password_confirm: String){
        
        let urlString = "https://ls123server.herokuapp.com/api/auth"
        
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "name": "\(name)",
            "email": "\(email)",
            "password": "\(password)",
            "password_confirm": "\(password_confirm)"
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                let resultData = String(data: data!, encoding: .utf8)!
                print("result:\(resultData)")
                print("response:\(response)")
                
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }
    }
}
