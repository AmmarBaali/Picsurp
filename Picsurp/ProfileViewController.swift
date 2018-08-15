//
//  ProfileViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-13.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import Foundation

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var gotologin: UIButton!

    @IBAction func LogOutButton(_ sender: Any) {
    
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        //Go To Login Page
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

