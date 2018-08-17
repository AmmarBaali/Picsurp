//
//  LoginViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-13.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var usernameLabel: UILabel!
    var username:String = ""
    var firstNameString = "WRONG"
    var lastNameString  = "WRONG"
    var emailString     = "WRONG"
    var FBid            = "WRONG"
    
    @IBOutlet weak var gotologin: UIButton!
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        fetchProfile()
        
    }
    
    
    func fetchProfile() {
        print("fetch profile")
        let parameters = ["fields": "email, id, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) -> Void in
            
            if error != nil{
                print(error)
                return
            }
            
            // Get the info from FB and set them locally
            let data:[String:AnyObject] = result as! [String : AnyObject]
            print("---USER INFO---")
            print(data["first_name"]!)
            print(data["last_name"]!)
            print(data["email"]!)
            print(data["id"]!)
            
            self.firstNameString          = data["first_name"]            as! String
            self.lastNameString           = data["last_name"]             as! String
            self.emailString              = data["email"]                 as! String
            self.FBid                     = data["id"]                    as! String
        })
    }
    
    
    // THESE ARE 3 MANDATORY FUNCTIONS FOR FB AUTH TO WORK
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")
        
        // Retrieve user current session
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Facebook authentication with Firebase error: ", error)
                return
            }
            // User is signed in - WRITING DOC TO DB
            print("* @ * @@ ********* Writing to DB")
            db.collection("users").document(self.emailString).setData([
                "firstName" :     self.firstNameString,
                "lastName"  :     self.lastNameString,
                "email"     :     self.emailString,
                "id"        :     self.FBid
                ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(self.emailString)")
                }
            }
        }
        
        //Go to Profile
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileStoryboardID") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    // THIS SENDS DATA TO OTHER VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MainViewController
        {
            let vc = segue.destination as? MainViewController
        }
        
        if segue.destination is ProfileViewController
        {
            let vc = segue.destination as? ProfileViewController
            vc?.emailAddress = emailString
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
