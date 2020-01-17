//
//  API.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/05.
//  Copyright © 2020 remuty. All rights reserved.
//

import Foundation

class API {
    
    static func fetchPosts(following: [Int],completion: @escaping ([PostsInfo]) -> Swift.Void) {
        
        let url = URL(string: "https://ls123server.herokuapp.com/posts")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let info = try JSONDecoder().decode([PostsInfo].self, from: jsonData)
                var posts:[PostsInfo] = []
                //フォロー中のユーザーの投稿を抽出
                for i in 0..<info.count {
                    for data in following{
                        if info[i].user_id == data {
                            posts.append(info[i])
                        }
                    }
                }
                completion(posts)
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
    
    static func fetchUserInfo(completion: @escaping ([UserInfo.Data]) -> Swift.Void) {
        
        let url = URL(string: "https://ls123server.herokuapp.com/users")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let info = try JSONDecoder().decode([UserInfo.Data].self, from: jsonData)
                completion(info)
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
                //                let resultData = String(data: data!, encoding: .utf8)!
                //                print("result:\(resultData)")
                
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
                //                let resultData = String(data: data!, encoding: .utf8)!
                //                print("result:\(resultData)")
                
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
                //                let resultData = String(data: data!, encoding: .utf8)!
                //                print("result:\(resultData)")
                
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
    
    static func follow(followedId: Int,isFollow: Bool){
        
        var urlSting = ""
        //フォロー済みなら解除
        if isFollow{
            urlSting = "delete"
        }
        let myId = UserDefaults.standard.integer(forKey: "id")
        let url = URL(string: "https://ls123server.herokuapp.com/relationships/\(urlSting)")
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "follower_id": "\(myId)",
            "followed_id": "\(followedId)"
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                //                let resultData = String(data: data!, encoding: .utf8)!
                //                print("result:\(resultData)")
                
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }
    }
    
    static func fetchRelationship(completion: @escaping([Int]) -> Swift.Void) {
        
        let id = UserDefaults.standard.integer(forKey: "id")
        let url = URL(string: "https://ls123server.herokuapp.com/users/\(id)/following")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let info = try JSONDecoder().decode([UserInfo.Data].self, from: jsonData)
                var idArray: [Int] = []
                for data in info{
                    idArray.append(data.id)
                }
                completion(idArray)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
