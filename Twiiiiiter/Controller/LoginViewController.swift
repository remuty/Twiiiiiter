//
//  LoginViewController.swift
//  Twiiiiiter
//
//  Created by remuty on 2020/01/15.
//  Copyright © 2020 remuty. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    
    fileprivate var info: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ログイン情報があるならログイン画面を飛ばす
        //        if UserDefaults.standard.object(forKey: "id") != nil{
        //            self.performSegue(withIdentifier: "login", sender: nil)
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        API.login(email: emailTextField.text!, password: passwordTextField.text!)
        
        if UserDefaults.standard.object(forKey: "id") != nil{
            self.performSegue(withIdentifier: "login", sender: nil)
        }
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
