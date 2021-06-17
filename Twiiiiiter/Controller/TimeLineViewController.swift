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
    
    let animationView = AnimationView()
    let screenSize = UIScreen.main.bounds.size
    var message = ""
    fileprivate var chats: [ChatsInfo] = []
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
        
        startAnimation()
        API.fetchRelationship(completion: { (idArray) in
            self.following = idArray
            self.fetch()
        })
        
        //Rails ActionCableと繋ぐ
        self.client = ActionCableClient(url: URL(string: "wss://ls123server.herokuapp.com/cable")!)
        client.connect()
        
        client.onConnected = {
            print("Connected!")
            self.roomChannel = self.client.create("ChatRoomChannel")
            if let roomChannel = self.roomChannel {
                roomChannel.onReceive = { (JSON : Any?, error : Error?) in
                    // 新しい投稿があると再読み込み
                    if JSON != nil {
                        self.fetch()
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
        
        //キーボードに合わせてtextField位置調整
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //フォローが変更されたらチャットを再取得
        API.fetchRelationship(completion: { (idArray) in
            let saveFollowing = self.following
            self.following = idArray
            if saveFollowing != self.following {
                self.fetch()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //投稿の数
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの内容
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! TableViewCell
        let idx = chats.count - indexPath.row - 1
        cell.commentLabel.text = chats[idx].text
        cell.userNameLabel.text = chats[idx].user.name
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func postMessage(_ sender: Any) {
        if textField.text != ""{
            message = textField.text!
            API.postText(text: message)
            textField.text = ""
        }
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
    
    func fetch() {
        API.fetchChats(following: self.following,completion: { (chats) in
            self.chats = chats
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopAnimation()
            }
        })
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
