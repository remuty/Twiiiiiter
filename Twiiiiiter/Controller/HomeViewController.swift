//
//  HomeViewController.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/04.
//  Copyright © 2020 remuty. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var posts: [MyInfo.Posts] = []
    let id = UserDefaults.standard.integer(forKey: "id")
    let name = UserDefaults.standard.string(forKey: "name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        userNameLabel.text = name
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        API.fetchMyInfo(id: self.id, completion: { (posts) in
            self.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        cell.userNameLabel.text = name
        return cell
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
