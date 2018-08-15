//
//  MainViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-11.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import UIKit

class MainViewController: UIViewController{

    var username:String = ""
    @IBOutlet weak var usernameLabel:UILabel?
    @IBOutlet weak var gotologin: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel?.text = username
        
    }


    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

