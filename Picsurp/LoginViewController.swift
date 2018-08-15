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
    var userInfo =          ["firstNameDB"       : "WRONG",
                             "lastNameDB"        : "WRONG",
                             "emailAddressDB"    : "WRONG"]
    
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
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) -> Void in
            
            if error != nil{
                print(error)
                return
            }
            
            //  print("Result: \(result)")
            let data:[String:AnyObject] = result as! [String : AnyObject]
            print("---USER INFO---")
            print(data["first_name"]!)
            print(data["last_name"]!)
            print(data["email"]!)
            
            self.userInfo["firstNameDB"]    = data["first_name"]    as? String
            self.userInfo["lastNameDB"]     = data["last_name"]     as? String
            self.userInfo["emailAddressDB"] = data["email"]         as? String
        })
    }
    
    
    // THESE ARE MANDATORY 3
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileStoryboardID") as UIViewController
        present(vc, animated: true, completion: nil)
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Facebook authentication with Firebase error: ", error)
                return
            }
            // User is signed in
            //print("User signed in!")
            // Add a new document with a generated ID
            var ref: DocumentReference? = nil
            ref = db.collection("users").addDocument(data: [
                "firstName" :     self.userInfo["firstNameDB"],
                "lastName"  :     self.userInfo["lastNameDB"],
                "email"     :     self.userInfo["emailAddressDB"]
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
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
            vc?.username = userInfo["firstNameDB"]!
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
