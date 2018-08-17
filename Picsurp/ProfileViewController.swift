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
    var firstName       = ""
    var lastName        = ""
    var emailAddress    = ""
    var FBid            = ""
    var url             = URL(string: "https://google.com")
    
    
    @IBAction func LogOutButton(_ sender: Any) {
        //Logout and go to login page
        print("* @ * @@ ********* Logging out")
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("* @ * @@ ********* PROFILE viewDidLoad executed")
        if !emailAddress.isEmpty{
            let docRef = db.collection("users").document(emailAddress)
            docRef.getDocument(source: .cache) { (document, error) in
                if let document = document {
                    print("* @ * @@ ********* Email address not null. Reading DB")
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    self.firstName      = document.data()!["firstName"]     as! String
                    self.lastName       = document.data()!["lastName"]      as! String
                    self.emailAddress   = document.data()!["email"]         as! String
                    self.FBid           = document.data()!["id"]            as! String
                    DispatchQueue.main.async {
                        self.profileGreetingsLabel.text = "\(self.firstName) \(self.lastName)"
                    }
                    self.url = URL(string: "https://graph.facebook.com/\(self.FBid)/picture?type=large&return_ssl_resources=1")
                    let urlStr = self.url?.absoluteString
                    self.profileImage.imageFromServerURL(urlString: urlStr!)
                    print("* @ * @@ ********* self.firstName = \(self.firstName)")
                    print("* @ * @@ ********* emailAddress = \(self.emailAddress)")
                    print("* @ * @@ ********* profileGreetingsLabel = \(self.profileGreetingsLabel.text)")
                    print("* @ * @@ ********* url = \(self.url)")
                } else {
                    print("Document does not exist in cache")
                }

                
            }
        }
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


