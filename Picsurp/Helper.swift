//
//  Helper.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-19.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import Foundation
import FirebaseStorage

class Helper: UIViewController{

    
                /* FUNCTIONS RELATED TO ANIMATIONS & DISPLAY*/
    /* --------------------------------------------------------- */
    /* --------------------------------------------------------- */
    
    func fadeIn(image: UIImageView){
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
            image.alpha = 0.5
        }, completion: nil)
    }
    
    func fadeOut(image: UIImageView){
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            image.alpha = 0.0
        }, completion: nil)
    }
    

    
    
                /* FUNCTIONS RELATED TO STORAGE*/
    /* --------------------------------------------------------- */
    /* --------------------------------------------------------- */
    
    func uploadImageToStorage(photo: UIImage, name: String){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let photoRef = storageRef.child("images/\(name).jpg")
        let uploadData = UIImagePNGRepresentation(photo)
        photoRef.putData(uploadData!, metadata: nil)
    }
    
    
                /* FUNCTIONS RELATED TO FILES */
    /* --------------------------------------------------------- */
    /* --------------------------------------------------------- */
    
    func writeToFileInDocumentDirectory(filename: String, textToAdd: String){
        do {
            let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
            let url = dir.appendingPathComponent(filename)
            try textToAdd.appendLineToURL(fileURL: url as URL)
        }
        catch {
            print("Could not write to file")
        }
    }
    
    
    func readFileinDocumentDirectory(filename: String) -> String{
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filename)
            do {
                let content = try String(contentsOf: fileURL, encoding: .utf8)
                return content
            }
            catch let error as NSError {
                print("Ooooops! Something went wrong: \(error)")
                return "invalid"
            }
        }
        return "invalid"
    }
    
    
    //This OVERWRITES already existing files!
    func createFileinDocumentDirectory(filename: String){
        let blank = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filename)
            do {
                try blank.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch let error as NSError {
                print("Ooooops! Something went wrong: \(error)")
            }
        }
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
    
    
    func printDocumentDirectoryContent(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Document Folder Path: \(documentsPath)")
        
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(atPath: documentsPath)
            print("Document Folder Content: \(files)")
        }
        catch let error as NSError {
            print("Ooooops! Something went wrong: \(error)")
        }
    }
    
    func getImagesinDocumentDirectory() -> [String]{
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            let imageAbsolutePath = directoryContents.filter{ $0.pathExtension == "png" }
            let imageNames = imageAbsolutePath.map{ $0.lastPathComponent }
            //print("Image list:", imageNames)
            return imageNames
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    
    func checkIfExistinDocumentDirectory(filename: String) -> Bool{
        let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        let url = dir.appendingPathComponent(filename)
        
        let filePath = url.path
        if(FileManager.default.fileExists(atPath: filePath)){
            print("File \(filename) exists")
            return true
        } else {
            print("File \(filename) not found")
            return false
        }
    }
    
    func saveImage(image: UIImage, name: String) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(name)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func retrieveImage(name: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(name).path)
        }
        return nil
    }
    
    /* --------------------------------------------------------- */
    /* --------------------------------------------------------- */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
                 /* FUNCTIONS RELATED TO PHOTOS */
    /* --------------------------------------------------------- */
    /* --------------------------------------------------------- */
    
    func assignProfilePicToImageView(fbID: String, imageview: UIImageView){
        let url = URL(string: "https://graph.facebook.com/\(fbID)/picture?type=large&return_ssl_resources=1")
        let urlStr = url?.absoluteString
        imageview.imageFromServerURL(urlString: urlStr!)
    }
    

    
}
