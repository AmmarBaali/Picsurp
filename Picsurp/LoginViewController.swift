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

    var firstNameString = "INVALID"
    var lastNameString  = "INVALID"
    var emailString     = "INVALID"
    var FBidString      = "INVALID"
   
    let userDataFile    = "UserData"
    
    @IBAction func profileButton(_ sender: Any) {
        self.goToProfile()
    }
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        
        let position = CGPoint(x: 185, y: 550)
        loginButton.center = position
        loginButton.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // THESE 3 ARE MANDATORY FUNCTIONS FOR FB AUTH TO WORK
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Starting login")
        getUserDataFromFacebook()
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
                "id"        :     self.FBidString
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with email: \(self.emailString)")
                }
            }
        }
        self.goToProfile()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    
    func getUserDataFromFacebook() {
        print("---Getting Info From Facebook---")
        let parameters = ["fields": "email, id, first_name, last_name"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) -> Void in
            print(self.emailString)
             Helper().printDocumentDirectoryContent()
            let data:[String:AnyObject] = result as! [String : AnyObject]
            if error != nil{
                print(error!)
                return
            }
            
             Helper().createFileinDocumentDirectory(filename: self.userDataFile)
            
            print("---USER DATA---")
            print(data["first_name"]!)
            print(data["last_name"]!)
            print(data["email"]!)
            print(data["id"]!)
            
            self.firstNameString          = data["first_name"]            as! String
            self.lastNameString           = data["last_name"]             as! String
            self.emailString              = data["email"]                 as! String
            self.FBidString               = data["id"]                    as! String

            Helper().writeToFileInDocumentDirectory(filename: self.userDataFile, textToAdd: data["first_name"]   as! String)
            Helper().writeToFileInDocumentDirectory(filename: self.userDataFile, textToAdd: data["last_name"]    as! String)
            Helper().writeToFileInDocumentDirectory(filename: self.userDataFile, textToAdd: data["email"]        as! String)
            Helper().writeToFileInDocumentDirectory(filename: self.userDataFile, textToAdd: data["id"]           as! String)
        })
    }

    func goToProfile(){
        if(FBSDKAccessToken.current() != nil){
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileStoryboardID") as! ProfileViewController
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true, completion: nil)
        } else {
            print("User not logged in")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}


extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}
