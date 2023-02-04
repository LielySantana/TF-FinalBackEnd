//
//  LoginVC.swift
//  TikFinder
//
//  Created by krunal on 19/01/23.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    let userDefaults = UserDefaults.standard
    var userInfo: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        usernameTF.resignFirstResponder()
        if usernameTF.text!.isEmpty{
            let loader = self.loader()
            showAlert(title: "Error", msg: "Please enter username", vc: self)
            return
        } else {
            self.credentials(userData: usernameTF.text!)
            let vc = storyboard?.instantiateViewController(withIdentifier: "MainTabVC")
            appDel.window?.rootViewController = vc!
            
        }
        
    }
    
    
    func credentials(userData: String){
        var credentialData : [String:String] = (self.userDefaults.object(forKey: "credentials") as? [String:String]) ?? [:]
            userDefaults.set(userData, forKey: "credentials")
            print("Credentials saved")

    }
    
    
}
