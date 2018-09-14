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

    let localImages = Helper().getImagesinDocumentDirectory()
    let numberOfCellsPerRow: CGFloat = 3
    let menuViewController = PopMenuViewController()
    let manager = PopMenuManager.default
    var imageSelected = ""

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad -----------------")
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
        
        
        setupPopupMenu()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
        
    func setupPopupMenu(){
        let favoriteAction = PopMenuDefaultAction(title: "Favorite", image: UIImage(named: "star_48.png"), didSelect: { action in
            print("\(String(describing: action.title)) is tapped")
        })
        
        let deleteAction = PopMenuDefaultAction(title: "Delete", image: UIImage(named: "delete_48.png"), didSelect: { action in
            print("\(String(describing: action.title)) is tapped")
            Helper().printDocumentDirectoryContent()
            print("Image to be deleted NOW: \(self.imageSelected)")
            if (Helper().checkIfExistinDocumentDirectory(filename: self.imageSelected)){
                self.deleteFileinDocumentDirectory(filename: self.imageSelected)
            }
        })
        manager.addAction(favoriteAction)
        manager.addAction(deleteAction)
    }


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
        print("You selected cell #\(indexPath.item)! Image: \(localImages[indexPath.item])")
        print("didSelectItemAt: \(localImages[indexPath.item])")
        self.imageSelected = localImages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        //Setting the Image
        let photoCell = UIImageView(frame: CGRect(x: 28, y: 0, width: 70, height: 116))
        photoCell.image = retrieveImage(name: localImages[indexPath.item])
        photoCell.contentMode = .scaleAspectFit
        //Setting the image frame
        photoCell.backgroundColor = UIColor.gray
        photoCell.layer.cornerRadius = 8.0
        photoCell.clipsToBounds = true
        photoCell.layer.borderWidth = 1
        photoCell.layer.borderColor = UIColor.gray.cgColor
        
        //Handling long press
        let holdGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(imageHeld(holdGestureRecognizer:)))
        photoCell.isUserInteractionEnabled = true
        photoCell.addGestureRecognizer(holdGestureRecognizer)
        
        cell.addSubview(photoCell)
        return cell
    }
    
    
    @objc func imageHeld(holdGestureRecognizer: UILongPressGestureRecognizer) {
        if holdGestureRecognizer.state == UIGestureRecognizerState.began {
            let point = holdGestureRecognizer.location(in: self.collectionView)
            let indexPath = self.collectionView?.indexPathForItem(at: point)
            print("Long hold detected")
            if let index = indexPath {
                print("imageSelected Updated")
                self.imageSelected = localImages[index.row]
            } else {
                print("Could not find index path")
            }
            manager.present()
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
                print("File does not exist")
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
