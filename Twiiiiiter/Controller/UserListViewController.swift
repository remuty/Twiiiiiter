//
//  UserListViewController.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/04.
//  Copyright © 2020 remuty. All rights reserved.
//

import UIKit
import Lottie

class UserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let animationView = AnimationView()
    fileprivate var users: [UserInfo.Data] = []
    var following: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        API.fetchRelationship(completion: { (idArray) in
            self.following = idArray
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimation()
        API.fetchUserInfo(completion: { (info) in
            self.users = info
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopAnimation()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //記事の数
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell",for: indexPath) as! UserListCell
        cell.userNameLabel.text = users[indexPath.row].name
        //タグを設定
        cell.button.tag = users[indexPath.row].id
        //フォロー中なら選択状態に
        for data in self.following {
            if cell.button.tag == data {
                cell.button.isSelected = true
                cell.button.backgroundColor = .white
            }
        }
        //ボタンの処理
        cell.button.addTarget(self, action: #selector(follow(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func follow(_ sender: UIButton) {
        var isFollow = false
        sender.isSelected = true
        sender.backgroundColor = .white
        //フォローしているか確認
        API.fetchRelationship(completion: { (idArray) in
            self.following = idArray
        })
        for data in following {
            if sender.tag == data {
                isFollow = true
                sender.isSelected = false
                sender.backgroundColor = UIColor(red: 64/255, green: 153/255, blue: 247/255, alpha: 1)
            }
        }
        //フォローorフォロー解除
        API.follow(followedId: sender.tag, isFollow: isFollow)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func startAnimation(){
        let animation = Animation.named("circleScale")
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
