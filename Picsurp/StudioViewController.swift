//
//  StudioViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-09-15.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import UIKit

class StudioViewController: UIViewController {


    @IBOutlet var popoverMenu: UIView!
    @IBOutlet weak var studioImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popoverMenu.layer.cornerRadius = 10
        
        let imageName = String(Helper().readFileinDocumentDirectory(filename: "SelectedImage").filter { !" \n\t\r".contains($0) })
        studioImage.image = Helper().retrieveImage(filename: imageName)
    }
    
    
    @IBAction func popMenu(_ sender: Any) {
        self.view.addSubview(popoverMenu)
        popoverMenu.center = self.view.center
    }
    
    @IBAction func closeMenu(_ sender: Any) {
        self.popoverMenu.removeFromSuperview()
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        let imageFilename = String(Helper().readFileinDocumentDirectory(filename: "SelectedImage").filter {!" \n\t\r".contains($0)})
        Helper().deleteFileinDocumentDirectory(filename: imageFilename)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        //self.goToProfile()
        self.dismiss(animated: true, completion: nil)
    }

    func goToProfile(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileStoryboardID") as! ProfileViewController
        present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
