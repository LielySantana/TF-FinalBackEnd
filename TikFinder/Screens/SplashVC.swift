//
//  SplashVC.swift
//  TikFinder
//
//  Created by krunal on 19/01/23.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func signInPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        appDel.window?.rootViewController = vc!
    }
    
}
