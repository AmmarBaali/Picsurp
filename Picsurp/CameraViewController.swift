//
//  CameraViewController.swift
//  Picsurp
//
//  Created by Ammar Baali on 2018-08-11.
//  Copyright © 2018 ___AMMARBAALI___. All rights reserved.
//

import UIKit
import SwiftyCam
import FirebaseStorage

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate{
  
    @IBOutlet weak var captureButton: SwiftyRecordButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var goToLoginButton: UIButton!
    @IBOutlet weak var saveToCameraRollButton: UIButton!
    @IBOutlet weak var saveConfirmation: UIImageView!
    @IBOutlet weak var saveToStorage: UIButton!
    
    var fbID = ""
    var lastName = ""
    
    @IBAction func saveToStorage(_ sender: Any) {
        let timeInterval = NSDate().timeIntervalSince1970
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let photoRef = storageRef.child("images/\(self.lastName)-\(self.fbID)-\(timeInterval).jpg")
        let uploadData = UIImagePNGRepresentation(self.previewImage.image!)
        photoRef.putData(uploadData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // You can also access to download URL after upload.
            photoRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
    }
    
    @IBAction func saveToCameraRollButton(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(previewImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @IBAction func captureButton(_ sender: Any) {
        takePhoto()
    }
    @IBAction func profileButton(_ sender: Any) {
        self.goToProfile()
    }
    @IBAction func loginButton(_ sender: Any) {
        self.goToLogin()
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.goToCamera()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        view.bringSubview(toFront: profileButton)
        
        let userData =  Helper().readFileinDocumentDirectory(filename: "UserData")
        var userDataArray: [String] = []
        userData.enumerateLines { line, _ in
            userDataArray.append(line)
        }
        
        self.lastName    = userDataArray[1]
        self.fbID        = userDataArray[3]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //captureButton.isEnabled = true
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
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
        previewImage.image = photo
        
        profileButton.isHidden = true
        goToLoginButton.isHidden = true
        cancelButton.isHidden = false
        saveToCameraRollButton.isHidden = false
        saveToStorage.isHidden = false
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when startVideoRecording() is called
        // Called if a SwiftyCamButton begins a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection
    }

    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        //This happens when camera starts
        captureButton.isEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        //This happens when camera stops
        captureButton.isEnabled = false
    }
    
    
    
    
    
    func goToCamera(){
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CameraStoryboardID") as! CameraViewController
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    func goToProfile(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileStoryboardID") as! ProfileViewController
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    func goToLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
