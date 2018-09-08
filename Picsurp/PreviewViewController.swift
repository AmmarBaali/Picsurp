//
//  PreviewViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-25.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var saveConfirmation: UIImageView!
    @IBAction func saveToCameraRoll(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imageInPreview, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @IBOutlet weak var previewImageArea: UIImageView!
    var imageInPreview: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previewImageArea.image = imageInPreview
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            messagePopup(titleDisplayed: "Save Error", messageDisplayed: error.localizedDescription)
        } else {
            Helper().fadeIn(image: self.saveConfirmation)
            Helper().fadeOut(image: self.saveConfirmation)
        }
    }
    
    func messagePopup(titleDisplayed: String, messageDisplayed: String){
        let ac = UIAlertController(title: titleDisplayed, message: messageDisplayed, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
