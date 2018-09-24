//
//  CollectionViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-09-12.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import UIKit
import PopMenu

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    var localImages = Helper().getImagesinDocumentDirectory()
    var originalLocalImagesCount = Helper().getImagesinDocumentDirectory().count
    let numberOfCellsPerRow: CGFloat = 3
    var lastIndexPath = IndexPath(row: 0, section: 0)
    var itemNegativeDelta = 0
    let manager = PopMenuManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting up the layout of the Collection View
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 125, height: 125)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView?.collectionViewLayout = layout
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        setupPopupMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CollectionView - viewWillAppear -------------------------------------")
        print("originalLocalImagesCount= \(originalLocalImagesCount)")
        reloadCollectionView()
    }
    

        
    func setupPopupMenu(){
        let favoriteAction = PopMenuDefaultAction(title: "Favorite", image: UIImage(named: "star_48.png"), didSelect: { action in
            print("\(String(describing: action.title)) is tapped")
        })

        let deleteAction = PopMenuDefaultAction(title: "Delete", image: UIImage(named: "delete_48.png"), didSelect: { action in
            print("\(String(describing: action.title)) is tapped")
            
            let imageFilename = String(Helper().readFileinDocumentDirectory(filename: "SelectedImage").filter {!" \n\t\r".contains($0)})
            Helper().deleteFileinDocumentDirectory(filename: imageFilename)
            
            self.deleteCellAndUpdateCollectionView()
            self.reloadCollectionView()
        })
        
        manager.addAction(favoriteAction)
        manager.addAction(deleteAction)
    }
    
    func reloadCollectionView(){
        let actualLocalImagesCount = Helper().getImagesinDocumentDirectory().count
        while(actualLocalImagesCount != originalLocalImagesCount){
            if (actualLocalImagesCount > originalLocalImagesCount){
                insertCellAndUpdateCollectionView()
            } else if (actualLocalImagesCount < originalLocalImagesCount) {
                deleteCellAndUpdateCollectionView()
            }
        }
        DispatchQueue.main.async {
            let indexSet = IndexSet(integer: 0)
            self.collectionView?.reloadSections(indexSet)
        }
    }


    func deleteCellAndUpdateCollectionView(){
        self.collectionView?.performBatchUpdates({
            self.collectionView?.deleteItems(at: [lastIndexPath])
            originalLocalImagesCount -= 1
        }, completion: nil)
    }
    
    func insertCellAndUpdateCollectionView(){
        self.collectionView?.performBatchUpdates({
            localImages = Helper().getImagesinDocumentDirectory()
            self.collectionView?.insertItems(at: [IndexPath(row: 0, section: 0)])
            originalLocalImagesCount += 1
        }, completion: nil)
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("$$$$$ - numberOfSections -------------------------------------")

        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return originalLocalImagesCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageFile = "SelectedImage"
        //print("didSelectItemAt: \(localImages[indexPath.item])")
        Helper().createFileinDocumentDirectory(filename: selectedImageFile)
        Helper().writeToFileInDocumentDirectory(filename: selectedImageFile, textToAdd: localImages[indexPath.item])
        //print(indexPath)
        //print("localImagesCount = \(originalLocalImagesCount)")
        lastIndexPath = indexPath
        goToStudio()
    }
    
    func goToStudio(){
        let storyboard = UIStoryboard(name: "Studio", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudioStoryboardID") as! StudioViewController
        present(vc, animated: true, completion: nil)
    }


    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("cellForItemAt happeneed")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        //Setting the Image
        let photoCell = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
        
        localImages = Helper().getImagesinDocumentDirectory()
        photoCell.image = cropToBounds(image: Helper().retrieveImage(filename: localImages[indexPath.item])!, width: 125, height: 125)
        photoCell.clipsToBounds = true
        photoCell.layer.borderWidth = 1
        photoCell.layer.borderColor = UIColor.white.cgColor
        
        //Handling long press
        let holdGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(imageHeld(holdGestureRecognizer:)))
        photoCell.isUserInteractionEnabled = true
        photoCell.addGestureRecognizer(holdGestureRecognizer)
        
        cell.addSubview(photoCell)
        return cell
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
    @objc func imageHeld(holdGestureRecognizer: UILongPressGestureRecognizer) {
        if holdGestureRecognizer.state == UIGestureRecognizerState.began {
            print("long hold detetec")
            manager.present()
            
            let point = holdGestureRecognizer.location(in: self.collectionView)
            let indexPath = self.collectionView?.indexPathForItem(at: point)
            lastIndexPath = indexPath!
            
            
            let selectedImageFile = "SelectedImage"
            print("didHoldItemAt: \(indexPath)")
            print(localImages[lastIndexPath.item])
            Helper().createFileinDocumentDirectory(filename: selectedImageFile)
            Helper().writeToFileInDocumentDirectory(filename: selectedImageFile, textToAdd: localImages[lastIndexPath.item])
            

        }
    }

    

    


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    /*
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
        print("GGDF")
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
