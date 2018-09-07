//
//  PreviewViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-25.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var previewImageArea: UIImageView!
    var imageInPreview: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previewImageArea.image = imageInPreview
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
