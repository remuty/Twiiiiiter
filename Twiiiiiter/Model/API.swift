//
//  API.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/05.
//  Copyright © 2020 remuty. All rights reserved.
//

import Foundation

struct API {
    
    static func fetchPosts(completion: @escaping ([PostsInfo]) -> Swift.Void) {
        
        let url = URL(string: "https://ls123server.herokuapp.com/posts.json")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let info = try JSONDecoder().decode([PostsInfo].self, from: jsonData)
                completion(info)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func fetchMyInfo(id: Int,completion: @escaping ([MyInfo.Posts]) -> Swift.Void) {
        
        let url = URL(string: "https://ls123server.herokuapp.com/users/\(id)")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let info = try JSONDecoder().decode(MyInfo.self, from: jsonData)
                completion(info.posts)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func postText(text: String){
        
        let url = URL(string: "https://ls123server.herokuapp.com/posts")
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "text": "\(text)",
            "user_id": UserDefaults.standard.integer(forKey: "id")
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                let resultData = String(data: data!, encoding: .utf8)!
                print("result:\(resultData)")
                
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }
    }
    
    static func register(name: String,email: String,password: String,password_confirm: String){
        
        let url = URL(string: "https://ls123server.herokuapp.com/api/auth")
        let request = NSMutableURLRequest(url: url!)
        
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
                
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }
    }
    
    static func login(email: String,password: String){
        
        let url = URL(string: "https://ls123server.herokuapp.com/api/auth/sign_in")
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "email": "\(email)",
            "password": "\(password)"
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                let resultData = String(data: data!, encoding: .utf8)!
                print("result:\(resultData)")
                
                guard let jsonData = data else {
                    return
                }
                
                do {
                    let info = try JSONDecoder().decode(UserInfo.self, from: jsonData)
                    print("id=\(info.data.id)")
                    //ユーザー情報を端末に登録
                    UserDefaults.standard.set(info.data.id,forKey: "id")
                    UserDefaults.standard.set(info.data.name,forKey: "name")
                } catch {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }
    }
}
