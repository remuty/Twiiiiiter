//
//  TimeLineViewController.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/04.
//  Copyright © 2020 remuty. All rights reserved.
//

import UIKit
import Lottie
import ActionCableClient

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var message = "iOSなのだ"
    let animationView = AnimationView()
    let screenSize = UIScreen.main.bounds.size
    fileprivate var posts: [PostsInfo] = []
    var following: [Int] = []
    var client: ActionCableClient!
    var roomChannel: Channel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        self.client = ActionCableClient(url: URL(string: "wss://ls123server.herokuapp.com/cable")!)
        // Connect!
        client.connect()
        
        client.onConnected = {
            print("Connected!")
            self.roomChannel = self.client.create("ChatRoomChannel")
            if let roomChannel = self.roomChannel {
                roomChannel.onReceive = { (JSON : Any?, error : Error?) in
                    // 新しい投稿があると再読み込み
                    if let json = JSON {
                        API.fetchPosts(following: self.following,completion: { (posts) in
                            self.posts = posts
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.stopAnimation()
                            }
                        })
                    }
                    if let error = error {
                        print("Received: ", error)
                    }
                }
                
                roomChannel.onSubscribed = {
                    print("Subscribed")
                }
                
                roomChannel.onUnsubscribed = {
                    print("Unsubscribed")
                }
                
                roomChannel.onRejected = {
                    print("Rejected")
                }
            }
        }
        client.onDisconnected = {(error: Error?) in
            print("Disconnected!")
        }
        
        
        //キーボード
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification){
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        textField.frame.origin.y = screenSize.height - keyboardHeight - textField.frame.height
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        textField.frame.origin.y = 780
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
        UIView.animate(withDuration: duration){
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimation()
        API.fetchRelationship(completion: { (idArray) in
            self.following = idArray
        })
        API.fetchPosts(following: following,completion: { (posts) in
            self.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopAnimation()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //記事の数
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! TableViewCell
        let idx = posts.count - indexPath.row - 1
        cell.commentLabel.text = posts[idx].text
        cell.userNameLabel.text = posts[idx].user.name
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            message = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func postMessage(_ sender: Any) {
        API.postText(text: message)
    }
    
    func startAnimation(){
        let animation = Animation.named("circleLotate")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/1.5)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    func stopAnimation(){
        animationView.removeFromSuperview()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
