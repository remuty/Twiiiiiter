//
//  TimeLineViewController.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/04.
//  Copyright © 2020 remuty. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    var message = "iOSなのだ"
    
    fileprivate var info: [UserInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        API.fetchUserInfo(completion: { (info) in
            self.info = info
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //記事の数
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! TableViewCell
        cell.commentLabel.text = info[indexPath.row].text
        cell.userNameLabel.text = info[indexPath.row].user.name
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
