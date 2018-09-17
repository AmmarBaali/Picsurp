//
//  CollectionViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-09-12.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    let localImages = Helper().getImagesinDocumentDirectory()
    let numberOfCellsPerRow: CGFloat = 3
    var count  = Helper().getImagesinDocumentDirectory().count
    
    

    
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
    }
    

        
//    func setupPopupMenu(indexPath: IndexPath){
//        //print("PopupMenu started with:::::::::::: \(self.imageSelected)")
//
//        let favoriteAction = PopMenuDefaultAction(title: "Favorite", image: UIImage(named: "star_48.png"), didSelect: { action in
//            print("\(String(describing: action.title)) is tapped")
//        })
//
//        let deleteAction = PopMenuDefaultAction(title: "Delete", image: UIImage(named: "delete_48.png"), didSelect: { action in
//            print("\(String(describing: action.title)) is tapped")
//            self.deleteCell(indexPath: indexPath)
//        })
//
//        manager.addAction(favoriteAction)
//        manager.addAction(deleteAction)
//
//    }

//    func deleteCell(indexPath: IndexPath){
//        print("Section: \(indexPath.section)")
//        print("Item: \(indexPath.item )")
//        print("Image in delete func: \(self.imageSelected)")
//
//        self.collectionView?.performBatchUpdates({
//            self.deleteFileinDocumentDirectory(filename: self.imageSelected)
//            self.collectionView?.numberOfItems(inSection: 0)
//            self.collectionView?.reloadData()
//        })
//    }
    

    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return localImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageFile = "SelectedImage"
        print("didSelectItemAt: \(localImages[indexPath.item])")
        Helper().createFileinDocumentDirectory(filename: selectedImageFile)
        Helper().writeToFileInDocumentDirectory(filename: selectedImageFile, textToAdd: localImages[indexPath.item])
        goToStudio()
    }
    
    func goToStudio(){
        let storyboard = UIStoryboard(name: "Studio", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StudioStoryboardID") as! StudioViewController
        present(vc, animated: true, completion: nil)
    }


    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        //Setting the Image
        let photoCell = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
        
        photoCell.image = cropToBounds(image: Helper().retrieveImage(filename: localImages[indexPath.item])!, width: 125, height: 125)
        
        //photoCell.contentMode = .scaleAspectFit
        //Setting the image frame
        //photoCell.backgroundColor = UIColor.gray
        //photoCell.layer.cornerRadius = 8.0
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
//            let point = holdGestureRecognizer.location(in: self.collectionView)
//            let indexPath = self.collectionView?.indexPathForItem(at: point)
//            print("Long hold detected at point: \(String(describing: indexPath))-------------------")
//            print(count)
//            if let index = indexPath {
//                let manager = PopMenuManager.default
//                let imageSelected = localImages[index.row]
//                print("imageSelected Updated: \(localImages[index.row])")
//                print("Section: \(String(describing: indexPath?.section))")
//                print("Item: \(String(describing: indexPath?.item ))")
//                //print("***Image Selected Value= \(self.imageSelected)***")
//                //setupPopupMenu(indexPath: indexPath!)
//
//                let deleteAction = PopMenuDefaultAction(title: "Delete \(imageSelected.suffix(10))", image: UIImage(named: "delete_48.png"), didSelect: { action in
//                    print("\(String(describing: action.title)) is tapped")
//                    self.deleteFileinDocumentDirectory(filename: imageSelected)
//                })
//
//                manager.addAction(deleteAction)
//                manager.present()
//            } else {
//                print("Could not find index path")
//            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    func retrieveImage(name: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(name).path)
        }
        return nil
    }
    
    func deleteFileinDocumentDirectory(filename: String){
        var filePath = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0]
            filePath = dir.appendingFormat("/" + filename)
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: filePath) {
                try fileManager.removeItem(atPath: filePath)
                print("Deleted File: \(filename)")
            } else {
                print("File \(filename) does not exist")
            }
        }
        catch let error as NSError {
            print("Ooooops! Something went wrong: \(error)")
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
