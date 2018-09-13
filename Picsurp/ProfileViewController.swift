//
//  ProfileViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-13.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import Foundation
import SideMenu

class ProfileViewController: UIViewController{
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBAction func loginButton(_ sender: Any) {
        self.goToLogin()
    }
    @IBAction func cameraButton(_ sender: Any) {
        self.goToCamera()
    }
    @IBAction func showSettingsButton(_ sender: Any) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RightMenuNavigationController")
        present(vc!, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userData =  Helper().readFileinDocumentDirectory(filename: "UserData")
        var userDataArray: [String] = []
        userData.enumerateLines { line, _ in
            userDataArray.append(line)
        }
        
        let firstName   = userDataArray[0]
        let lastName    = userDataArray[1]
        //let email       = userDataArray[2]
        let fbID        = userDataArray[3]
        
        DispatchQueue.main.async {
            self.profileNameLabel.text = "\(firstName) \(lastName)"
        }
        
        let url = URL(string: "https://graph.facebook.com/\(fbID)/picture?type=large&return_ssl_resources=1")
        let urlStr = url?.absoluteString
        self.profileImage.imageFromServerURL(urlString: urlStr!)
        self.profileImage.backgroundColor = UIColor.white
        self.profileImage.layer.cornerRadius = 8.0
        self.profileImage.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        
    }
    
    func goToLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }
    func goToCamera(){
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CameraStoryboardID") as! CameraViewController
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
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
}

extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }
}
