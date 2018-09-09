//
//  SideMenuTableViewController.swift
//  SideMenu
//
//  Created by Jon Kent on 4/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SideMenu

class SideMenuTableViewController: UITableViewController {
    
 
    @IBAction func logOut(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        self.goToLogin()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Side Menu Table View Controller - viewDidLoad")
        // Set up settings pane backgroung image
        let imageView = UIImageView(image: UIImage(named: "settings_background"))
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0.25
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.backgroundView = imageView
        
        // refresh cell blur effect in case it changed
        tableView.reloadData()
        
        guard SideMenuManager.default.menuBlurEffectStyle == nil else {
            return
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! UITableViewVibrantCell
        
        cell.blurEffectStyle = SideMenuManager.default.menuBlurEffectStyle
        
        return cell
    }
    
    
    func goToLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }
    
}
