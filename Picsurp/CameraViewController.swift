//
//  CameraViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-11.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController{
  
    @IBOutlet weak var captureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 


    @IBAction func ProfileButton(_ sender: Any) {
        self.GoToProfile()
    }
    @IBAction func LoginButton(_ sender: Any) {
        self.GoToLogin()
    }
    
    func GoToProfile(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileStoryboardID") as! ProfileViewController
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    func GoToLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
