//
//  ProfileViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-13.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import Foundation

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileGreetingsLabel: UILabel!
    
    
    //Logout and go to login page
    @IBAction func LogOutButton(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.GoToLogin()
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        self.GoToLogin()
    }
    @IBAction func MainButton(_ sender: Any) {
        self.GoToMain()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            let userData =  Helper().readFileinDocumentDirectory(filename: "UserData")
            var userDataArray: [String] = []
            userData.enumerateLines { line, _ in
                userDataArray.append(line)
            }
            
            let firstName   = userDataArray[0]
            let lastName    = userDataArray[1]
            let email       = userDataArray[2]
            let fbID        = userDataArray[3]
            
            DispatchQueue.main.async {
                self.profileGreetingsLabel.text = "\(firstName) \(lastName)"
            }
            
            let url = URL(string: "https://graph.facebook.com/\(fbID)/picture?type=large&return_ssl_resources=1")
            let urlStr = url?.absoluteString
            self.profileImage.imageFromServerURL(urlString: urlStr!)
    }
    
    func GoToLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }
    func GoToMain(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainStoryboardID") as! MainViewController
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// This is to load the profile pic asynchronously
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }}
