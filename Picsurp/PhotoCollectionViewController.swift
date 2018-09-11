//
//  PhotoCollectionViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-09-09.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import UIKit
import PinterestLayout

class PhotoCollectionViewController: PinterestVC {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let text = "Some text. Some text. Some text. Some text."
        
        items = [
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),
            PinterestItem(image: UIImage(named: "camera_64")!, text: text),

        ]
    }
    

}
