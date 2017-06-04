//
//  SecondViewController.swift
//  TuneMinder
//
//  Created by Omri Gazitt on 5/31/17.
//  Copyright © 2017 Omri Gazitt. All rights reserved.
//

import UIKit
import Photos
import Firebase

class PhotosViewController: UIViewController,
                            UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var storageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // [START configurestorage]
        storageRef = Storage.storage().reference()
        // [END configurestorage]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // [START storageauth]
        // Using Cloud Storage for Firebase requires the user be authenticated. Here we are using
        // anonymous authentication.
/*
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously(completion: { (user: User?, error: Error?) in
                if let error = error {
                    //self.urlTextView.text = error.localizedDescription
                    //self.takePicButton.isEnabled = false
                } else {
                    //self.urlTextView.text = ""
                    //self.takePicButton.isEnabled = true
                }
            })
        }
        // [END storageauth]
  */
        // MARK: - Image Picker
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else { return }
        //let imagePath = Auth.auth().currentUser!.uid +
        //"/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let imagePath = "14257650079." + "\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageRef.child(imagePath).putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading: \(error)")
                //self.urlTextView.text = "Upload Failed"
                return
            }
            self.uploadSuccess(metadata!, storagePath: imagePath)
        }
        // switch to the tags tab bar item
        self.tabBarController?.selectedIndex = 2;

        /*
        //urlTextView.text = "Beginning Upload"
        // if it's a photo from the library, not an image from the camera
        if #available(iOS 8.0, *), let referenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceUrl], options: nil)
            let asset = assets.firstObject
            asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
                //let filePath = Auth.auth().currentUser!.uid +
                //"/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(imageFile!.lastPathComponent)"
                
                let filePath = "14257650079." + imageFile!.lastPathComponent
                
                // [START uploadimage]
                self.storageRef.child(filePath)
                    .putFile(from: imageFile!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading: \(error)")
                            //self.urlTextView.text = "Upload Failed"
                            return
                        }
                        self.uploadSuccess(metadata!, storagePath: filePath)
                }
                // [END uploadimage]
            })
        }
 */
        /*
        if let referenceUrl = info[UIImagePickerControllerReferenceURL] {
            
            ////
            let assetURL = URL(string: String(referenceUrl))
            let assets = PHAsset.fetchAssetsWithALAssetURLs([assetURL!], options: nil)
            let asset: PHAsset = assets.firstObject as! PHAsset
            let manager = PHImageManager.defaultManager()
            let requestSize =   PHImageManagerMaximumSize
            manager.requestImageForAsset(asset, targetSize: requestSize, contentMode: .AspectFit, options: nil, resultHandler: {(result, info)->Void in
                // Result is a UIImage
                // Either upload the UIImage directly or write it to a file
                let imageData = UIImageJPEGRepresentation(result!, 0.8)
                let imagePath = FIRAuth.auth()!.currentUser!.uid + "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"
                print ("filePath: ", imagePath)
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                self.storageRef.child(imagePath)
                    .putData(imageData!, metadata: metadata) { (metadata, error) in
                        if let error = error {
                            print("Error uploading: \(error.description)")
                            return
                        }
                        self.sendMessage([Constants.MessageFields.imageUrl: self.storageRef.child((metadata?.path)!).description])
                        print("Succeded")
                }
                
            })
        }
 */
        
    }
    
    func uploadSuccess(_ metadata: StorageMetadata, storagePath: String) {
        print("Upload Succeeded!")
        //self.urlTextView.text = metadata.downloadURL()?.absoluteString
        UserDefaults.standard.set(storagePath, forKey: "storagePath")
        UserDefaults.standard.synchronize()
        //self.downloadPicButton.isEnabled = true
        
        // switch to the tags tab bar item
        self.tabBarController?.selectedIndex = 2;
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
        // switch to the tags tab bar item
        self.tabBarController?.selectedIndex = 2;
    }
    
    /*
import UIKit
import FirebaseStorage

class PhotosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let storage = Storage.storage()

        // Create a root reference
        let storageRef = storage.reference()

        // File located on disk
        let localFile = URL(string: "path/to/image")!
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/rivers.jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
*/

}

